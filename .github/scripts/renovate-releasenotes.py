#!/usr/bin/env python3
import sys
import io
import typer

from git import Repo
from loguru import logger
from pathlib import Path

from ruamel.yaml import YAML
from ruamel.yaml.comments import CommentedMap
from ruamel.yaml.scalarstring import LiteralScalarString, PreservedScalarString
from typing import List

app = typer.Typer(add_completion=False)


def _setup_logging(debug):
    """
    Setup the log formatter for this script
    """

    log_level = "INFO"
    if debug:
        log_level = "DEBUG"

    logger.remove()
    logger.add(
        sys.stdout,
        colorize=True,
        format="<level>{message}</level>",
        level=log_level,
    )


def extract_images(images_dict):
    images = {}
    for key, value in images_dict.items():
        if isinstance(value, dict) and 'image' in value:
            image_info = value['image']
            if isinstance(image_info, dict):
                images[key] = {
                    'repository': image_info.get('repository'),
                    'tag': image_info.get('tag')
                }
    return images

def bump_patch_version(chart_metadata):
    """
    Bump the patch version in the chart metadata.
    """
    version = chart_metadata.get("version", "0.0.0")  # Default to 0.0.0 if not present
    major, minor, patch = map(int, version.split('.'))
    patch += 1  # Increment the patch version
    new_version = f"{major}.{minor}.{patch}"
    chart_metadata["version"] = new_version
    return chart_metadata


@app.command()
def main(
        chart_folders: List[Path] = typer.Argument(
            ..., help="Folders containing the chart to process"),
        check_branch: str = typer.Option(
            None, help="The branch to compare against."),
        chart_base_folder: Path = typer.Option(
            "charts", help="The base folder where the charts reside."),
        debug: bool = False,
):
    _setup_logging(debug)

    git_repository = Repo(search_parent_directories=True)

    if check_branch:
        logger.info(f"Trying to find branch {check_branch}...")
        branch = next(
            (ref for ref in git_repository.remotes.origin.refs if ref.name == check_branch),
            None
        )
    else:
        logger.info(f"Trying to determine default branch...")
        branch = next(
            (ref for ref in git_repository.remotes.origin.refs if ref.name == "origin/HEAD"),
            None
        )

    if not branch:
        logger.error(
            f"Could not find branch {check_branch} to compare against.")
        raise typer.Exit(1)

    logger.info(f"Comparing against branch {branch}")

    for chart_folder in chart_folders:
        chart_folder = chart_base_folder.joinpath(chart_folder)
        if not chart_folder.is_dir():
            logger.error(f"Could not find folder {str(chart_folder)}")
            raise typer.Exit(1)

        chart_metadata_file = chart_folder.joinpath('Chart.yaml')
        values_file = chart_folder.joinpath('values.yaml')

        if not chart_metadata_file.is_file():
            logger.error(f"Could not find file {str(chart_metadata_file)}")
            raise typer.Exit(1)

        if not values_file.is_file():
            logger.error(f"Could not find file {str(values_file)}")
            raise typer.Exit(1)

        logger.info(f"Updating changelog annotation for chart {chart_folder}")

        yaml = YAML(typ=['rt', 'string'])
        yaml.indent(mapping=2, sequence=4, offset=2)
        yaml.explicit_start = True
        yaml.preserve_quotes = True
        yaml.width = 4096

        old_chart_metadata = yaml.load(
            git_repository.git.show(f"{branch}:{chart_metadata_file}")
        )
        new_chart_metadata = yaml.load(chart_metadata_file.read_text())

        old_values = yaml.load(
            git_repository.git.show(f"{branch}:{values_file}")
        )
        new_values = yaml.load(values_file.read_text())

        try:
            old_chart_dependencies = old_chart_metadata["dependencies"]
        except KeyError:
            old_chart_dependencies = []

        try:
            new_chart_dependencies = new_chart_metadata["dependencies"]
        except KeyError:
            new_chart_dependencies = []

        annotations = []
        for dependency in new_chart_dependencies:
            old_dep = None
            if "alias" in dependency.keys():
                old_dep = next(
                    (old_dep for old_dep in old_chart_dependencies if "alias" in old_dep.keys(
                    ) and old_dep["alias"] == dependency["alias"]),
                    None
                )
            else:
                old_dep = next(
                    (old_dep for old_dep in old_chart_dependencies if old_dep["name"] == dependency["name"]),
                    None
                )

            add_annotation = False
            if old_dep:
                if dependency["version"] != old_dep["version"]:
                    add_annotation = True
            else:
                add_annotation = True

            if add_annotation:
                if "alias" in dependency.keys():
                    annotations.append({
                        "kind": "changed",
                        "description": f"Upgraded `{dependency['name']}` chart dependency to version {dependency['version']} for alias '{dependency['alias']}'"
                    })
                else:
                    annotations.append({
                        "kind": "changed",
                        "description": f"Upgraded `{dependency['name']}` chart dependency to version {dependency['version']}"
                    })

        # Compare image digests in values.yaml
        old_images = extract_images(old_values)
        new_images = extract_images(new_values)

        for component, new_image in new_images.items():
            old_image = old_images.get(component)

            if old_image is None:
                annotations.append({
                    "kind": "added",
                    "description": f"Added new image for `{component}` with repository {new_image['repository']} and tag {new_image['tag']}"
                })
            else:
                if old_image['repository'] != new_image['repository'] or old_image['tag'] != new_image['tag']:
                    annotations.append({
                        "kind": "changed",
                        "description": f"Updated image for `{component}` from {old_image['tag']} to {new_image['tag']}"
                    })

        if annotations:
            annotations_stream = io.StringIO()
            yaml.dump_all([annotations], annotations_stream)

            annotations_string = annotations_stream.getvalue().strip()
            annotations_stream.close()

            if "annotations" not in new_chart_metadata:
                new_chart_metadata["annotations"] = CommentedMap()

            new_chart_metadata["annotations"]["artifacthub.io/changes"] = LiteralScalarString(annotations_string)

            logger.debug(f"Annotations: {annotations_string}")
            logger.debug(new_chart_metadata)

            new_chart_metadata = bump_patch_version(new_chart_metadata)

        with chart_metadata_file.open("w") as f:
            yaml.exclude_start = False
            yaml.dump(new_chart_metadata, f)



if __name__ == "__main__":
    app()
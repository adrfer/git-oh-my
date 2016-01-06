#!/usr/bin/env bash

set -e
set -u

# Confirm uninstall

read -r -p 'Sure to uninstall (y/n [n])? '

if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
  echo 'Ok then, nothing much to see here.'
  exit 0
fi

# Define repo variable

local_repo="${HOME}/.git-oh-my"

# Remove local repo

if [[ -d "${local_repo}" ]]; then
  echo -n "Removing ${local_repo}..."
  rm -rf "${local_repo}"
  echo ' done.'
else
  echo "Local repo ${local_repo} not found."
fi

# Define variables for files

local_gitconfig="${HOME}/.gitconfig"
local_gitignore="${HOME}/.gitignore"

# Remove symlinks to local files

files=( "${local_gitconfig}" "${local_gitignore}" )

for file in "${files[@]}"; do
  if [[ -L "${file}" ]]; then
    echo -n "Removing ${file}..."
    rm -f "${file}"
    echo ' done.'
  else
    echo "Local profile ${file} not found."
  fi
done

# Check and restore backup, if any

read -r -p "Check for ${local_repo} backups? (y/n [n])? "

if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
  echo 'Ok then, good to go!'
  exit 0
fi

local_repo_backup_pattern='.git-oh-my copy*'
local_repo_backup=$(find "${HOME}" -maxdepth 1 -type d -name "${local_repo_backup_pattern}" | sort -r | head -n1)

if [[ -n "${local_repo_backup}" ]]; then
  read -r -p "Last backup was ${local_repo_backup}. Restore it (y/n [n])? "

  if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    echo -n "Restoring ${local_repo_backup}..."
    mv -f "${local_repo_backup}" "${local_repo}"
    echo ' done.'
  fi
else
  echo "No backups found for ${local_repo}."
fi

echo 'Uninstall successful, farewell!'
exit 0
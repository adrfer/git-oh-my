#!/usr/bin/env bash

set -e
set -u

# Fail fast if not on OS X

if [[ "$(uname)" != 'Darwin' ]]; then
  echo 'Ooops, this runs on OS X only.'
  exit 1
fi

# Check if git is available

if ! command -v 'git' &>/dev/null; then
  echo -n 'Ooops, git not found. '
  read -r -p 'Install it (y/n [n])? '

  if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
    echo 'Ok then, nothing much to see here.'
    exit 0
  fi

  if ! command -v 'xcode-select' &>/dev/null; then
    echo 'Ooops, Xcode not found. '
    read -r -p 'Install it (y/n [n])? '

    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
      echo 'Ok then, nothing much to see here.'
      exit 0
    fi

    if ! 'xcode-select' --install &>/dev/null; then
      exit 1
    fi
  fi
fi

# Define repo variables

remote_repo='https://github.com/adrfer/git-oh-my.git'
local_repo="${HOME}/.git-oh-my"

# Check local repo

if [[ ! -d "${local_repo}" ]]; then
  echo -n "Ooops, local repo ${local_repo} not found. "
  read -r -p 'Clone it (y/n [n])? '

  if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
    echo 'Ok then, nothing much to see here.'
    exit 0
  fi

  # Clone remote repo

  echo -n "Cloning repo into ${local_repo}..."

  if git clone --quiet "${remote_repo}" "${local_repo}" &>/dev/null; then
    echo ' done.'
  else
    echo 'Ooops, there was an error, try again.'
    exit 1
  fi
fi

# Update local repo

cd "${local_repo}"

echo -n "Updating local repo ${local_repo}..."

if git pull --quiet --rebase origin master &>/dev/null; then
  echo ' done.'
else
  echo 'Ooops, there was an error, try again.'
  exit 1
fi

# Define variables for files

remote_gitconfig="${local_repo}/gitconfig"
remote_gitignore="${local_repo}/gitignore"

local_gitconfig="${HOME}/.gitconfig"
local_gitignore="${HOME}/.gitignore"

# Link local profile

ln -sf "${remote_gitconfig}" "${local_gitconfig}"
ln -sf "${remote_gitignore}" "${local_gitignore}"

echo 'Update successful, enjoy!'
exit 0
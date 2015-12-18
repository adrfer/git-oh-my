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

if [[ -d "${local_repo}" ]]; then
  echo -n "Backing up ${local_repo}..."
  mv -f "${local_repo%/}"{," copy $(date +%s)"}
  echo ' done.'
fi

# Clone the remote repo into the local repo

echo -n "Cloning repo into ${local_repo}..."

if git clone --quiet "${remote_repo}" "${local_repo}" &>/dev/null; then
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

# Link local files

ln -sf "${remote_gitconfig}" "${local_gitconfig}"
ln -sf "${remote_gitignore}" "${local_gitignore}"

# Set up credentials

echo 'Now, setting up your credentials...'

name_prompt='Your name: '
read -r -p "${name_prompt}" name
git config --global user.name "${name}"

email_prompt='Your email: '
read -r -p "${email_prompt}" email
git config --global user.email "${email}"

echo 'Install successful, enjoy!'
exit 0
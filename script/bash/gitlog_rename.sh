#!/bin/bash

git filter-branch --force --env-filter '
        # GIT_AUTHOR_NAMEの書き換え
        if [ "$GIT_AUTHOR_NAME" = "変更前" ];
        then
                GIT_AUTHOR_NAME="変更後";
        fi
        # GIT_AUTHOR_EMAILの書き換え
        if [ "$GIT_AUTHOR_EMAIL" = "変更前" ];
        then
                GIT_AUTHOR_EMAIL="変更後";
        fi
        # GIT_COMMITTER_NAMEの書き換え
        if [ "$GIT_COMMITTER_NAME" = "変更前" ];
        then
                GIT_COMMITTER_NAME="変更後";
        fi
        # GIT_COMMITTER_EMAILの書き換え
        if [ "$GIT_COMMITTER_EMAIL" = "変更前" ];
        then
                GIT_COMMITTER_EMAIL="変更後";
        fi
        ' -- --all

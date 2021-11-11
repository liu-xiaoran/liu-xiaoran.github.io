git filter-branch -f --env-filter "
GIT_AUTHOR_NAME='liuxiaoran';
GIT_AUTHOR_EMAIL='mk9540@163.com';
GIT_COMMITTER_NAME='liuxiaoran';
GIT_COMMITTER_EMAIL='mk9540@163.com'
" HEAD
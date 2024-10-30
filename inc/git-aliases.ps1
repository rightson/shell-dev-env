function git.pull { git pull }
function git.pull.origin.branch { git pull origin (git rev-parse --abbrev-ref HEAD) }
function git.pull.origin.branch.rebase { git pull origin (git rev-parse --abbrev-ref HEAD) --rebase }
function git.push { git push }
function git.push.origin.branch { git push origin (git rev-parse --abbrev-ref HEAD) }
function git.push.origin.branch.tags { git push origin (git rev-parse --abbrev-ref HEAD) --tags }
function git.status { git status -v }
function git.checkout { git checkout }
function git.commit { git commit }
function git.commit.message { param($message) git commit -m $message }
function git.commit.amend { git commit --amend }
function g { git }
function ga { git add}
function gaa { git add --all}
function gapa { git add --patch}
function gau { git add -u}
function gaus { git add -u; git status }
function gauw { git add -u; git diff --word-diff --cached; git status }
function gauv { git add -u; git diff --word-diff --cached; git status }
function gbc { git rev-parse --abbrev-ref HEAD }
function gb { git branch}
function gba { git branch -a}
function gbda { git branch --merged | Where-Object { $_ -notmatch '^\*|\s*master\s*$' } | ForEach-Object { git branch -d $_.Trim() } }
function gbl { git blame -b -w}
function gbnm { git branch --no-merged}
function gbr { git branch --remote}
function gbs { git bisect}
function gbsb { git bisect bad}
function gbsg { git bisect good}
function gbsr { git bisect reset}
function gbss { git bisect start}
function gc { git commit -v }
function gca { git commit -v -a}
function gca! { git commit -v -a --amend }
function gcan! { git commit -v -a -s --no-edit --amend }
function gcam { param($message) git commit -a -m $message }
function gcb { param($branch) git checkout -b $branch }
function gcf { git config --list}
function gcl { git clone --recursive}
function gclean { git clean -fd}
function gpristine { git reset --hard; git clean -dfx }
function gcm { git checkout master }
function gcmsg { param($message) git commit -m $message }
function gco { git checkout}
function gcount { git shortlog -sn}
function gcp { git cherry-pick}
function gcs { git commit -S }
function gd { git diff}
function gd.vim { git diff } 
function gd.np { git --no-pager diff }
function gd.wd { git diff --word-diff }
function gdca { git diff --cached}
function gdca.vim { git diff --cached } 
function gdca.np { git --no-pager diff --cached }
function gdca.wd { git diff --word-diff --cached }
function gdct { git describe --tags (git rev-list --tags --max-count=1) }
function gdt { git diff-tree --no-commit-id --name-only -r}
function gdv { git diff -w $args | vim - }
function gdw { git diff --word-diff}
function gf { git fetch}
function gfa { git fetch --all --prune}
function gfg { param($pattern) git ls-files | Select-String $pattern }
function gfo { git fetch origin}
function gp { git push }
function gpd { git push --dry-run}
function gpoat { git push origin --all; git push origin --tags }
function gpob { git push origin (git rev-parse --abbrev-ref HEAD) }
function gpobt { git push origin (git rev-parse --abbrev-ref HEAD) --tags }
function gpu { git push upstream}
function gpv { git push -v }
function gr { git remote}
function gra { git remote add}
function grb { git rebase}
function grba { git rebase --abort}
function grbc { git rebase --continue}
function grbi { git rebase -i}
function grbm { git rebase master}
function grbs { git rebase --skip}
function grh { git reset HEAD}
function grhh { git reset HEAD --hard}
function grmv { git remote rename}
function grrm { git remote remove}
function grset { git remote set-url}
function grt { Set-Location (git rev-parse --show-toplevel) }
function gru { git reset --}
function grup { git remote update}
function grv { git remote -v}
function gsb { git status -sb}
function gsd { git svn dcommit}
function gsi { git submodule init}
function gsps { git show --pretty=short --show-signature}
function gsr { git svn rebase}
function gss { git status -s}
function gst { git status}
function gsta { git stash}
function gstaa { git stash apply}
function gstd { git stash drop}
function gstl { git stash list}
function gstp { git stash pop}
function gsts { git stash show --text}
function gsu { git submodule update}
function gts { git tag -s}
function gtt { git tag | Select-Object -Last 1 }
function gtv { git tag | Sort-Object -Property @{Expression={[Version]$_}} }
function gunignore { git update-index --no-assume-unchanged }
function gunwip { 
    $lastCommit = git log -n 1 | Select-String -Pattern "\-\-wip\-\-"
    if ($lastCommit) {
        git reset HEAD~1
    }
}
function gup { git pull --rebase}
function gupv { git pull --rebase -v}
function glum { git pull upstream master}
function gwch { git whatchanged -p --abbrev-commit --pretty=medium}
function gwip { 
    git add -A
    git ls-files --deleted -z | ForEach-Object { git rm $_ }
    git commit -m "--wip--" 
}
function Get-GitStatus { git status }
function Get-GitLog { git log }
function Get-GitBranch { git branch }
function Switch-GitBranch { param($branch) git checkout $branch }
function New-GitBranch { param($branch) git checkout -b $branch }
function Remove-GitBranch { param($branch) git branch -d $branch }
function Merge-GitBranch { param($branch) git merge $branch }
function Push-GitBranch { param($branch) git push origin $branch }
function Pull-GitBranch { param($branch) git pull origin $branch }
function git_log_pretty {
    git log --graph --pretty='format:%C(red)%h%C(reset) %C(yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%cr)%C(reset) %C(bold blue)[%an]%C(reset)' --abbrev-commit --date=relative
}
function glp { git_log_pretty }
function git_current_branch { git rev-parse --abbrev-ref HEAD }
function gpc {
    $branch = git_current_branch
    git push origin $branch
}
function gplc {
    $branch = git_current_branch
    git pull origin $branch
}
function gfp { git fetch --all --prune }
function gir {
    param($commit = "master")
    git rebase -i $commit
}
function gdp { git diff HEAD^ }
function gsl { git show --name-only }
function gcm {
    param($message)
    git commit -m $message
}
function gac {
    param($message)
    git add -A
    git commit -m $message
}
function gacp {
    param($message)
    git add -A
    git commit -m $message
    $branch = git_current_branch
    git push origin $branch
}
function gundo { git reset HEAD~1 --soft }
function grh {
    param($branch = (git_current_branch))
    git fetch origin
    git reset --hard origin/$branch
}
function gclean { git clean -fd }
function gstm {
    param($message)
    git stash push -m $message
}
function gstal { git stash apply }
function gstpl { git stash pop }
function gcpa { git cherry-pick --abort }
function gcpc { git cherry-pick --continue }
function grba { git rebase --abort }
function grbc { git rebase --continue }
function gma { git merge --abort }
function gmc { git merge --continue }

export ENV_ROOT=$(cd `dirname ${BASH_SOURCE[0]}`/.. && pwd)

source $ENV_ROOT/env/bash/variables.bash
source $ENV_ROOT/env/bash/util.bash
source $ENV_ROOT/env/bash/statusbar.bash
source $ENV_ROOT/env/bash/git-aliases.bash

source $ENV_ROOT/env/sh/variables.sh
source $ENV_ROOT/env/sh/util.sh
source $ENV_ROOT/env/sh/aliases.sh
source $ENV_ROOT/env/sh/git-prompt.sh


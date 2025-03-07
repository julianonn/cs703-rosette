# README

Dependencies
<!-- - OPTIONAL: [Docker](https://www.docker.com/) -->
- Python 3ish
- [Jupyter](https://jupyter.org/)
- [Racket](https://racket-lang.org/)
- [Rosette](https://docs.racket-lang.org/rosette-guide/index.html): constraint based solver based on racket




## Setup (No Docker)
1. Download & install [Racket](https://racket-lang.org/), add to path
2. Run:
```sh
# optional but recommended: virtualenv
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt  # this installs jupyter

# install rosette
raco pkg install rosette

jupyter notebook
```
3. Change environment variables at the top of your target notebook as required, as you may need to add racket to the venv path manually (see `test.ipynb`)
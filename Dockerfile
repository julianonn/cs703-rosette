FROM racket/racket:8.16

# Install Jupyter
RUN apt-get update

#RUN apt-get install -y python3-pip

#RUN pip3 install jupyter

RUN apt-get install -y python3-pip jupyter-core jupyter-notebook

# Install iRacket
RUN raco pkg install --auto iracket 

RUN raco iracket install

# Install Rosette
RUN raco pkg install --auto rosette

# weird workaround to make working directory appear in the right place
# RUN useradd -m user
# WORKDIR /workspace
# RUN chown -R user:user /workspace
# USER user

# Expose Jupyter port
EXPOSE 8888

# Start Jupyter notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--notebook-dir=/workspace"]
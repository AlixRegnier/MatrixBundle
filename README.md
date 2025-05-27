# MatrixBundle
Repo of repos for testing k-mer matrix compression

## Structure

```bash
MatrixBundle
├── bin/              #Directory with symbolic links to all programs
├── BitmatrixShuffle/ #Submodule to bitmatrix columns reordering
├── kmindex/          #Submodule to kmindex (fork with compression)
├── Makefile          #Compilation instructions for all programs
├── recipe.def        #Container Apptainer/Singularity recipe
└── reorder_json/     #Program to reorder kmindex JSON file
```

## Cloning this repo

You need to import this repo with this command, it will recursively add submodules (and their submodules):
```bash
git clone --recursive https://www.github.com/AlixRegnier/MatrixBundle.git
```
Otherwise, you can clone this repo and use:
```bash
git submodule update --recursive --init
```

## Compiling

### 1. Building Apptainer image

At the root of the repo, there is a Apptainer/Singularity recipe called ``recipe.def``.
It makes easier to compile programs and to use them.

First build the container:
```bash
#Build a container called 'container.sif' from recipe 'recipe.def'
apptainer build container.sif recipe.def
```

### 2. Use container and compile

Now you need to use container to compile programs
```bash
#Go to the root of the repo
cd MatrixBundle

#Run container in shell mode
apptainer shell container.sif

#Compile programs
make compile
```

And the programs should be compiled

## Using compiled programs

All programs have a help which is displayed when the are ran without any argument. When you use the container, you should be able to directly use programs as the executables should have been added to PATH. Otherwise, you can find symbolic links to programs in ``/path/to/MatrixBundle/bin``.

You can either use container in shell mode
```bash
apptainer shell container.sif
```
or single command
```bash
apptainer exec container.sif [COMMANDLINE]
```

## Other stuff

Useful link if you need to let docker accessing other directories:
<https://apptainer.org/docs/user/main/bind_paths_and_mounts.html>

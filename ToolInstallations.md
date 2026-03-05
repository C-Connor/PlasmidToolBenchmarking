# Tool Installations

Code that was used to install tools and the error messages that occurred


We attempted to fix obvious error messages (e.g. a package was missing from the dependency list), but we could not extensively troubleshoot installtions given the number of tools.

## Failed Install

### mlplasmids

<details>
<summary>Install commands</summary>

```bash
git clone https://gitlab.com/mmb-umcu/mlplasmids.git
cd mlplasmids
conda env create -f envs/mlplasmids.yml
conda activate mlplasmids
Rscript scripts/run_mlplasmids.R data/abaumannii_example.fasta examples/abaumanni_prediction_example.tab 0.7 'Acinetobacter baumannii'
```

</details>
<details>
<summary>Error message (stderr)</summary>

```bash
Downloading git repo https://gitlab.com/mmb-umcu/mlplasmids.git
Installing mlplasmids
trying URL 'https://cran.rstudio.com/src/contrib/kernlab_0.9-33.tar.gz'
Content type 'application/x-gzip' length 1025337 bytes (1001 KB)
==================================================
downloaded 1001 KB

Installing kernlab
'/home/cccon/miniconda3/envs/mlplasmids/lib/R/bin/R' --no-site-file  \
  --no-environ --no-save --no-restore --quiet CMD INSTALL  \
  '/tmp/cccon/RtmpeSEBmy/devtools9720f35692f8b/kernlab'  \
  --library='/home/cccon/miniconda3/envs/mlplasmids/lib/R/library'  \
  --install-tests 

* installing *source* package 'kernlab' ...
** package 'kernlab' successfully unpacked and MD5 sums checked
** libs
dcauchy.c: In function 'dcauchy':
dcauchy.c:110:14: error: expected ')' before 'FCONE'
     wa, &inc FCONE);
              ^~~~~
dcauchy.c:132:68: error: expected ')' before 'FCONE'
     F77_CALL(dsymv)("U", &n, &one, A, &n, s, &inc, &zero, wa, &inc FCONE);
                                                                    ^~~~~
dcauchy.c:156:68: error: expected ')' before 'FCONE'
     F77_CALL(dsymv)("U", &n, &one, A, &n, s, &inc, &zero, wa, &inc FCONE);
                                                                    ^~~~~
make: *** [/home/cccon/miniconda3/envs/mlplasmids/lib/R/etc/Makeconf:160: dcauchy.o] Error 1
ERROR: compilation failed for package 'kernlab'
* removing '/home/cccon/miniconda3/envs/mlplasmids/lib/R/library/kernlab'
* restoring previous '/home/cccon/miniconda3/envs/mlplasmids/lib/R/library/kernlab'
Installation failed: Command failed (1)
trying URL 'https://cran.rstudio.com/src/contrib/seqinr_4.2-36.tar.gz'
Content type 'application/x-gzip' length 3539927 bytes (3.4 MB)
==================================================
downloaded 3.4 MB

Installing seqinr
trying URL 'https://cran.rstudio.com/src/contrib/ade4_1.7-23.tar.gz'
Content type 'application/x-gzip' length 3372316 bytes (3.2 MB)
==================================================
downloaded 3.2 MB

Installing ade4
trying URL 'https://cran.rstudio.com/src/contrib/RcppArmadillo_15.2.3-1.tar.gz'
Content type 'application/x-gzip' length 2123239 bytes (2.0 MB)
==================================================
downloaded 2.0 MB

Installing RcppArmadillo
'/home/cccon/miniconda3/envs/mlplasmids/lib/R/bin/R' --no-site-file  \
  --no-environ --no-save --no-restore --quiet CMD INSTALL  \
  '/tmp/cccon/RtmpeSEBmy/devtools9720f253db1d4/RcppArmadillo'  \
  --library='/home/cccon/miniconda3/envs/mlplasmids/lib/R/library'  \
  --install-tests 

* installing *source* package 'RcppArmadillo' ...
** package 'RcppArmadillo' successfully unpacked and MD5 sums checked
** libs
In file included from ../inst/include/current/armadillo:115:0,
                 from ../inst/include/RcppArmadillo/interface/RcppArmadilloForward.h:57,
                 from ../inst/include/RcppArmadillo/Lighter:37,
                 from RcppArmadillo.cpp:21:
../inst/include/current/armadillo_bits/compiler_setup.hpp:159:6: error: #error "*** newer compiler required; need at least gcc 8.1 ***"
     #error "*** newer compiler required; need at least gcc 8.1 ***"
      ^~~~~
make: *** [/home/cccon/miniconda3/envs/mlplasmids/lib/R/etc/Makeconf:167: RcppArmadillo.o] Error 1
ERROR: compilation failed for package 'RcppArmadillo'
* removing '/home/cccon/miniconda3/envs/mlplasmids/lib/R/library/RcppArmadillo'
Installation failed: Command failed (1)
'/home/cccon/miniconda3/envs/mlplasmids/lib/R/bin/R' --no-site-file  \
  --no-environ --no-save --no-restore --quiet CMD INSTALL  \
  '/tmp/cccon/RtmpeSEBmy/devtools9720f10403fac/ade4'  \
  --library='/home/cccon/miniconda3/envs/mlplasmids/lib/R/library'  \
  --install-tests 

ERROR: dependency 'RcppArmadillo' is not available for package 'ade4'
* removing '/home/cccon/miniconda3/envs/mlplasmids/lib/R/library/ade4'
Installation failed: Command failed (1)
'/home/cccon/miniconda3/envs/mlplasmids/lib/R/bin/R' --no-site-file  \
  --no-environ --no-save --no-restore --quiet CMD INSTALL  \
  '/tmp/cccon/RtmpeSEBmy/devtools9720f34fb8dcb/seqinr'  \
  --library='/home/cccon/miniconda3/envs/mlplasmids/lib/R/library'  \
  --install-tests 

ERROR: dependency 'ade4' is not available for package 'seqinr'
* removing '/home/cccon/miniconda3/envs/mlplasmids/lib/R/library/seqinr'
Installation failed: Command failed (1)
'/home/cccon/miniconda3/envs/mlplasmids/lib/R/bin/R' --no-site-file  \
  --no-environ --no-save --no-restore --quiet CMD INSTALL  \
  '/tmp/cccon/RtmpeSEBmy/file9720f609ebd82'  \
  --library='/home/cccon/miniconda3/envs/mlplasmids/lib/R/library'  \
  --install-tests 

ERROR: dependency 'seqinr' is not available for package 'mlplasmids'
* removing '/home/cccon/miniconda3/envs/mlplasmids/lib/R/library/mlplasmids'
Installation failed: Command failed (1)
Error in library(mlplasmids) : there is no package called 'mlplasmids'
Calls: suppressMessages -> withCallingHandlers -> library
Execution halted
```
</details>

<details>
<summary>Error message (stdout)</summary>

```bash
[1] "Installing mlplasmids; please be patient, as this involves downloading a large dataset..."
x86_64-conda_cos6-linux-gnu-c++  -I"/home/cccon/miniconda3/envs/mlplasmids/lib/R/include" -DNDEBUG   -DNDEBUG -D_FORTIFY_SOURCE=2 -O2  -I/home/cccon/miniconda3/envs/mlplasmids/include -Wl,-rpath-link,/home/cccon/miniconda3/envs/mlplasmids/lib   -fpic  -fvisibility-inlines-hidden  -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -I/home/cccon/miniconda3/envs/mlplasmids/include -fdebug-prefix-map=/home/conda/feedstock_root/build_artifacts/r-base_1560889951366/work=/usr/local/src/conda/r-base-3.5.1 -fdebug-prefix-map=/home/cccon/miniconda3/envs/mlplasmids=/usr/local/src/conda-prefix  -c brweight.cpp -o brweight.o
x86_64-conda_cos6-linux-gnu-c++  -I"/home/cccon/miniconda3/envs/mlplasmids/lib/R/include" -DNDEBUG   -DNDEBUG -D_FORTIFY_SOURCE=2 -O2  -I/home/cccon/miniconda3/envs/mlplasmids/include -Wl,-rpath-link,/home/cccon/miniconda3/envs/mlplasmids/lib   -fpic  -fvisibility-inlines-hidden  -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -I/home/cccon/miniconda3/envs/mlplasmids/include -fdebug-prefix-map=/home/conda/feedstock_root/build_artifacts/r-base_1560889951366/work=/usr/local/src/conda/r-base-3.5.1 -fdebug-prefix-map=/home/cccon/miniconda3/envs/mlplasmids=/usr/local/src/conda-prefix  -c ctable.cpp -o ctable.o
x86_64-conda_cos6-linux-gnu-c++  -I"/home/cccon/miniconda3/envs/mlplasmids/lib/R/include" -DNDEBUG   -DNDEBUG -D_FORTIFY_SOURCE=2 -O2  -I/home/cccon/miniconda3/envs/mlplasmids/include -Wl,-rpath-link,/home/cccon/miniconda3/envs/mlplasmids/lib   -fpic  -fvisibility-inlines-hidden  -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -I/home/cccon/miniconda3/envs/mlplasmids/include -fdebug-prefix-map=/home/conda/feedstock_root/build_artifacts/r-base_1560889951366/work=/usr/local/src/conda/r-base-3.5.1 -fdebug-prefix-map=/home/cccon/miniconda3/envs/mlplasmids=/usr/local/src/conda-prefix  -c cweight.cpp -o cweight.o
x86_64-conda_cos6-linux-gnu-cc -I"/home/cccon/miniconda3/envs/mlplasmids/lib/R/include" -DNDEBUG   -DNDEBUG -D_FORTIFY_SOURCE=2 -O2  -I/home/cccon/miniconda3/envs/mlplasmids/include -Wl,-rpath-link,/home/cccon/miniconda3/envs/mlplasmids/lib   -fpic  -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -I/home/cccon/miniconda3/envs/mlplasmids/include -fdebug-prefix-map=/home/conda/feedstock_root/build_artifacts/r-base_1560889951366/work=/usr/local/src/conda/r-base-3.5.1 -fdebug-prefix-map=/home/cccon/miniconda3/envs/mlplasmids=/usr/local/src/conda-prefix  -c dbreakpt.c -o dbreakpt.o
x86_64-conda_cos6-linux-gnu-cc -I"/home/cccon/miniconda3/envs/mlplasmids/lib/R/include" -DNDEBUG   -DNDEBUG -D_FORTIFY_SOURCE=2 -O2  -I/home/cccon/miniconda3/envs/mlplasmids/include -Wl,-rpath-link,/home/cccon/miniconda3/envs/mlplasmids/lib   -fpic  -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -I/home/cccon/miniconda3/envs/mlplasmids/include -fdebug-prefix-map=/home/conda/feedstock_root/build_artifacts/r-base_1560889951366/work=/usr/local/src/conda/r-base-3.5.1 -fdebug-prefix-map=/home/cccon/miniconda3/envs/mlplasmids=/usr/local/src/conda-prefix  -c dcauchy.c -o dcauchy.o
checking whether the C++ compiler works... yes
checking for C++ compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether the compiler supports GNU C++... yes
checking whether x86_64-conda_cos6-linux-gnu-c++ accepts -g... yes
checking for x86_64-conda_cos6-linux-gnu-c++ option to enable C++11 features... none needed
checking how to run the C++ preprocessor... x86_64-conda_cos6-linux-gnu-c++ -E
checking whether the compiler supports GNU C++... (cached) yes
checking whether x86_64-conda_cos6-linux-gnu-c++ accepts -g... (cached) yes
checking for x86_64-conda_cos6-linux-gnu-c++ option to enable C++11 features... (cached) none needed
checking what system we are on... running Linux on x86_64
checking whether we have a suitable tempdir... /tmp/cccon
checking whether on Linux... yes
checking whether R CMD SHLIB can already compile OpenMP programs... yes
checking whether on macOS... no
checking for OpenMP... found and suitable
configure: creating ./config.status
config.status: creating inst/include/RcppArmadillo/config/RcppArmadilloConfigGenerated.h
config.status: creating src/Makevars
x86_64-conda_cos6-linux-gnu-c++  -I"/home/cccon/miniconda3/envs/mlplasmids/lib/R/include" -DNDEBUG -I../inst/include -DARMA_USE_CURRENT -I"/home/cccon/miniconda3/envs/mlplasmids/lib/R/library/Rcpp/include" -DNDEBUG -D_FORTIFY_SOURCE=2 -O2  -I/home/cccon/miniconda3/envs/mlplasmids/include -Wl,-rpath-link,/home/cccon/miniconda3/envs/mlplasmids/lib  -fopenmp -fpic  -fvisibility-inlines-hidden  -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -I/home/cccon/miniconda3/envs/mlplasmids/include -fdebug-prefix-map=/home/conda/feedstock_root/build_artifacts/r-base_1560889951366/work=/usr/local/src/conda/r-base-3.5.1 -fdebug-prefix-map=/home/cccon/miniconda3/envs/mlplasmids=/usr/local/src/conda-prefix  -c RcppArmadillo.cpp -o RcppArmadillo.o
```

</details>

Attempting Installation through R

<details>
<summary>Install commands</summary>

```bash
#reusing conda env from above
R
```

```R
>install.packages("devtools")
```

</details>

<details>
<summary>Error message</summary>

```R
--- Please select a CRAN mirror for use in this session ---
Secure CRAN mirrors 

 1: 0-Cloud [https]                      2: Australia (Canberra) [https]      
 3: Australia (Melbourne 1) [https]      4: Australia (Melbourne 2) [https]   
 5: Austria (Wien) [https]               6: Belgium (Brussels) [https]        
 7: Brazil (PR) [https]                  8: Brazil (SP 1) [https]             
 9: Brazil (SP 2) [https]               10: Bulgaria [https]                  
11: Canada (MB) [https]                 12: Canada (ON 1) [https]             
13: Canada (ON 2) [https]               14: Chile (Santiago) [https]          
15: China (Beijing 1) [https]           16: China (Beijing 2) [https]         
17: China (Beijing 3) [https]           18: China (Hefei) [https]             
19: China (Hong Kong) [https]           20: China (Jinan) [https]             
21: China (Lanzhou) [https]             22: China (Nanjing) [https]           
23: China (Shanghai 2) [https]          24: China (Shenzhen) [https]          
25: China (Wuhan) [https]               26: Costa Rica [https]                
27: Cyprus [https]                      28: Denmark [https]                   
29: East Asia [https]                   30: Ecuador (Cuenca) [https]          
31: Finland (Helsinki) [https]          32: France (Lyon 1) [https]           
33: France (Lyon 2) [https]             34: France (Paris 1) [https]          
35: Germany (Erlangen) [https]          36: Germany (G<U+00F6>ttingen) [https]
37: Germany (Leipzig) [https]           38: Germany (M<U+00FC>nster) [https]  
39: Greece [https]                      40: Hungary [https]                   
41: Iceland [https]                     42: India (Bhubaneswar) [https]       
43: India (New Delhi) [https]           44: Indonesia (Banda Aceh) [https]    
45: Iran (Mashhad) [https]              46: Italy (Milano) [https]            
47: Italy (Padua) [https]               48: Japan (Yonezawa) [https]          
49: Korea (Gyeongsan-si) [https]        50: Mexico (Mexico City) [https]      
51: Mexico (Texcoco) [https]            52: Morocco [https]                   
53: Netherlands (Dronten) [https]       54: New Zealand [https]               
55: Poland [https]                      56: Saudi Arabia (Riyadh) [https]     
57: Spain (A Coru<U+00F1>a) [https]     58: Spain (Madrid) [https]            
59: Sweden (Ume<U+00E5>) [https]        60: Switzerland (Zurich 1) [https]    
61: Taiwan (Taipei) [https]             62: UK (Bristol) [https]              
63: UK (London 1) [https]               64: USA (IA) [https]                  
65: USA (MI) [https]                    66: USA (MO) [https]                  
67: USA (OH) [https]                    68: USA (OR) [https]                  
69: USA (PA 1) [https]                  70: USA (TN) [https]                  
71: USA (UT) [https]                    72: United Arab Emirates [https]      
73: Uruguay [https]                     74: (other mirrors)                   


Selection: 2
Warning message:
package 'devtools' is not available (for R version 3.5.1)
```

</details>

### PlasClass

<details>
<summary>Install commands</summary>

```bash
conda create --name plasclass
conda activate plasclass
conda install python setuptools
git clone https://github.com/Shamir-Lab/PlasClass.git
cd PlasClass
python setup.py sdist
pip install dist/plasclass_dpellow-0.1.tar.gz
```

</details>
<details>
<summary>Error message</summary>

```bash
Processing ./dist/plasclass_dpellow-0.1.tar.gz
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Preparing metadata (pyproject.toml) ... done
INFO: pip is looking at multiple versions of plasclass-dpellow to determine which version is compatible with other requirements. This could take a while.
ERROR: Ignored the following yanked versions: 1.14.0rc1
ERROR: Ignored the following versions that require a different python version: 1.10.0 Requires-Python >=3.8,<3.12; 1.10.0rc1 Requires-Python >=3.8,<3.12; 1.10.0rc2 Requires-Python >=3.8,<3.12; 1.10.1 Requires-Python >=3.8,<3.12; 1.11.0 Requires-Python >=3.9,<3.13; 1.11.0rc1 Requires-Python >=3.9,<3.13; 1.11.0rc2 Requires-Python >=3.9,<3.13; 1.11.1 Requires-Python >=3.9,<3.13; 1.11.2 Requires-Python >=3.9,<3.13; 1.11.3 Requires-Python >=3.9,<3.13; 1.6.2 Requires-Python >=3.7,<3.10; 1.6.3 Requires-Python >=3.7,<3.10; 1.7.0 Requires-Python >=3.7,<3.10; 1.7.1 Requires-Python >=3.7,<3.10; 1.7.2 Requires-Python >=3.7,<3.11; 1.7.3 Requires-Python >=3.7,<3.11; 1.8.0 Requires-Python >=3.8,<3.11; 1.8.0rc1 Requires-Python >=3.8,<3.11; 1.8.0rc2 Requires-Python >=3.8,<3.11; 1.8.0rc3 Requires-Python >=3.8,<3.11; 1.8.0rc4 Requires-Python >=3.8,<3.11; 1.8.1 Requires-Python >=3.8,<3.11; 1.9.0 Requires-Python >=3.8,<3.12; 1.9.0rc1 Requires-Python >=3.8,<3.12; 1.9.0rc2 Requires-Python >=3.8,<3.12; 1.9.0rc3 Requires-Python >=3.8,<3.12; 1.9.1 Requires-Python >=3.8,<3.12
ERROR: Could not find a version that satisfies the requirement scipy==1.10.0 (from plasclass-dpellow) (from versions: 0.8.0, 0.9.0, 0.10.0, 0.10.1, 0.11.0, 0.12.0, 0.12.1, 0.13.0, 0.13.1, 0.13.2, 0.13.3, 0.14.0, 0.14.1, 0.15.0, 0.15.1, 0.16.0, 0.16.1, 0.17.0, 0.17.1, 0.18.0, 0.18.1, 0.19.0, 0.19.1, 1.0.0, 1.0.1, 1.1.0, 1.2.0, 1.2.1, 1.2.2, 1.2.3, 1.3.0, 1.3.1, 1.3.2, 1.3.3, 1.4.0, 1.4.1, 1.5.0, 1.5.1, 1.5.2, 1.5.3, 1.5.4, 1.6.0, 1.6.1, 1.9.2, 1.9.3, 1.11.4, 1.12.0rc1, 1.12.0rc2, 1.12.0, 1.13.0rc1, 1.13.0, 1.13.1, 1.14.0rc2, 1.14.0, 1.14.1, 1.15.0rc1, 1.15.0rc2, 1.15.0, 1.15.1, 1.15.2, 1.15.3, 1.16.0rc1, 1.16.0rc2, 1.16.0, 1.16.1, 1.16.2, 1.16.3, 1.17.0rc1, 1.17.0rc2, 1.17.0)
ERROR: No matching distribution found for scipy==1.10.0
```

</details>


Attempted manual install of scipy 1.10.0

<details>
<summary>Scipy install command</summary>

```bash
conda install scipy=1.10.0
```
</details>

<details>
<summary>Error</summary>

```bash
Channels:
 - conda-forge
 - bioconda
 - defaults
Platform: linux-64
Collecting package metadata (repodata.json): done
Solving environment: failed

LibMambaUnsatisfiableError: Encountered problems while solving:
  - package scipy-1.10.0-py310h8deb116_0 requires python >=3.10,<3.11.0a0, but none of the providers can be installed

Could not solve for environment specs
The following packages are incompatible
├─ pin on python =3.14 * is installable and it requires
│  └─ python =3.14 *, which can be installed;
└─ scipy =1.10.0 * is not installable because there are no viable options
   ├─ scipy 1.10.0 would require
   │  └─ python >=3.10,<3.11.0a0 *, which conflicts with any installable versions previously reported;
   ├─ scipy 1.10.0 would require
   │  └─ python >=3.11,<3.12.0a0 *, which conflicts with any installable versions previously reported;
   ├─ scipy 1.10.0 would require
   │  └─ python >=3.8,<3.9.0a0 *, which conflicts with any installable versions previously reported;
   └─ scipy 1.10.0 would require
      └─ python >=3.9,<3.10.0a0 *, which conflicts with any installable versions previously reported.

Pins seem to be involved in the conflict. Currently pinned specs:
 - python=3.14
```

</details>

### plASgraph2

<details>
<summary>Install commands</summary>

```bash
conda create --name plasgraph2
conda activate plasgraph2
conda install python setuptools
git clone https://github.com/cchauve/plASgraph2.git
pip3 install -r plASgraph2/requirements.txt
```

</details>
<details>
<summary>Error message</summary>

```bash
Collecting protobuf==3.19.4 (from -r plASgraph2/requirements.txt (line 1))
  Using cached protobuf-3.19.4-py2.py3-none-any.whl.metadata (828 bytes)
Collecting NetworkX==2.8.3 (from -r plASgraph2/requirements.txt (line 2))
  Using cached networkx-2.8.3-py3-none-any.whl.metadata (5.0 kB)
Collecting Pandas==1.4.1 (from -r plASgraph2/requirements.txt (line 3))
  Using cached pandas-1.4.1.tar.gz (4.9 MB)
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Preparing metadata (pyproject.toml) ... done
Collecting NumPy==1.22.2 (from -r plASgraph2/requirements.txt (line 4))
  Using cached numpy-1.22.2.zip (11.4 MB)
  Installing build dependencies ... done
  Getting requirements to build wheel ... error
  error: subprocess-exited-with-error
  
  _ Getting requirements to build wheel did not run successfully.
  _ exit code: 1
  __> [32 lines of output]
      Traceback (most recent call last):
        File "/home/cccon/miniconda3/envs/plasgraph2/lib/python3.14/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 389, in <module>
          main()
          ~~~~^^
        File "/home/cccon/miniconda3/envs/plasgraph2/lib/python3.14/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 373, in main
          json_out["return_val"] = hook(**hook_input["kwargs"])
                                   ~~~~^^^^^^^^^^^^^^^^^^^^^^^^
        File "/home/cccon/miniconda3/envs/plasgraph2/lib/python3.14/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 137, in get_requires_for_build_wheel
          backend = _build_backend()
        File "/home/cccon/miniconda3/envs/plasgraph2/lib/python3.14/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 70, in _build_backend
          obj = import_module(mod_path)
        File "/home/cccon/miniconda3/envs/plasgraph2/lib/python3.14/importlib/__init__.py", line 88, in import_module
          return _bootstrap._gcd_import(name[level:], package, level)
                 ~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        File "<frozen importlib._bootstrap>", line 1398, in _gcd_import
        File "<frozen importlib._bootstrap>", line 1371, in _find_and_load
        File "<frozen importlib._bootstrap>", line 1314, in _find_and_load_unlocked
        File "<frozen importlib._bootstrap>", line 491, in _call_with_frames_removed
        File "<frozen importlib._bootstrap>", line 1398, in _gcd_import
        File "<frozen importlib._bootstrap>", line 1371, in _find_and_load
        File "<frozen importlib._bootstrap>", line 1342, in _find_and_load_unlocked
        File "<frozen importlib._bootstrap>", line 938, in _load_unlocked
        File "<frozen importlib._bootstrap_external>", line 759, in exec_module
        File "<frozen importlib._bootstrap>", line 491, in _call_with_frames_removed
        File "/tmp/cccon/pip-build-env-86zbt761/overlay/lib/python3.14/site-packages/setuptools/__init__.py", line 16, in <module>
          import setuptools.version
        File "/tmp/cccon/pip-build-env-86zbt761/overlay/lib/python3.14/site-packages/setuptools/version.py", line 1, in <module>
          import pkg_resources
        File "/tmp/cccon/pip-build-env-86zbt761/overlay/lib/python3.14/site-packages/pkg_resources/__init__.py", line 2172, in <module>
          register_finder(pkgutil.ImpImporter, find_on_path)
                          ^^^^^^^^^^^^^^^^^^^
      AttributeError: module 'pkgutil' has no attribute 'ImpImporter'. Did you mean: 'zipimporter'?
      [end of output]
  
  note: This error originates from a subprocess, and is likely not a problem with pip.
ERROR: Failed to build 'NumPy' when getting requirements to build wheel
```

Attempted manual install of Numpy but no difference

</details>

## Run Failed

### Recycler

<details>
<summary>Install commands</summary>

```bash
conda create --name recycler
conda activate recycler
conda install python setuptools bwa
git clone https://github.com/Shamir-Lab/Recycler.git
cd Recycler
python setup.py sdist
pip install dist/recycler-0.62.tar.gz
```
</details>

<details>
<summary>Run commands</summary>

```bash
#needs mapped file
make_fasta_from_fastg.py -g assembly_graph.fastg -o assembly_graph.nodes.fasta
bwa index assembly_graph.nodes.fasta
bwa mem assembly_graph.nodes.fasta R1.fastq.gz R2.fastq.gz | samtools view -buS - > reads_pe.bam
samtools view -bF 0x0800 reads_pe.bam > reads_pe_primary.bam
samtools sort reads_pe_primary.bam -o reads_pe_primary.sort.bam
samtools index reads_pe_primary.sort.bam

recycle.py -g assembly_graph.fastg -k 55 -b reads_pe_primary.sort.bam -i True
```

</details>
<details>
<summary>Error message</summary>

```bash
Traceback (most recent call last):
  File "/home/cccon/miniconda3/envs/recycler/bin/recycle.py", line 100, in <module>
    long_self_loops = get_long_self_loops(G, min_length, SEQS)
  File "/home/cccon/miniconda3/envs/recycler/lib/python3.14/site-packages/recyclelib/utils.py", line 205, in get_long_self_loops
    for nd in G.nodes_with_selfloops():
              ^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'DiGraph' object has no attribute 'nodes_with_selfloops'
```

</details>

### gplas

<details>
<summary>Install commands</summary>

```bash
conda create --name gplas
conda activate gplas
conda install snakemake
git clone https://gitlab.com/sirarredondo/gplas.git

```
</details>

<details>
<summary>Run commands</summary>

```bash
cd gplas
./gplas.sh -i test/faecium_graph.gfa -c mlplasmids -s 'Enterococcus faecium' -n 'installation'
```

</details>
<details>
<summary>Error message</summary>

```bash
Creating (only the first-time) a conda environment to install and run snakemake                                                                                                                                                                                             
AttributeError in line 1 of /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/gplas/mlplasmidssnake.smk:                                                                                                                                                            
module 'collections' has no attribute 'Mapping'                                                                                                                                                                                                                             
  File "/home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/gplas/mlplasmidssnake.smk", line 1, in <module>                                                                                                                                                           
AttributeError in line 1 of /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/gplas/mlplasmidssnake.smk:                                                                                                                                                            
module 'collections' has no attribute 'Mapping'                                                                                                                                                                                                                             
  File "/home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/gplas/mlplasmidssnake.smk", line 1, in <module>                                                                                                                                                           
Looks like something went wrong! 
```

</details>

### PlasmidID

<details>
<summary>Install commands</summary>

```bash
conda create --name plasmidid
conda install -c conda-forge -c bioconda plasmidid
download_plasmid_database.py -o plasmididDB
#takes a long time to download
```
</details>

<details>
<summary>Run commands</summary>

```bash
plasmidID -1 ../NK_H22_076_1.fastq.gz -2 ../NK_H22_076_2.fastq.gz -d plasmididDB/2026-01-12_plasmids.fasta -c ../spades/contigs.fasta --no-trim -s test
```
</details>

<details>
<summary>Error message</summary>

```bash
------------------
Starting plasmidID version:1.6.4
------------------


CHECKING DEPENDENCIES AND MANDATORY FILES

DEPENDENCY                    STATUS
----------                    ------
gawk                         INSTALLED
blastn                       INSTALLED
bowtie2-build                INSTALLED
bowtie2                      INSTALLED
bedtools                     INSTALLED
prokka                       INSTALLED
samtools                     INSTALLED
mash                         INSTALLED
circos                       INSTALLED

Default output directory is: /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/testdata/plasmidid

Log will be saved in: /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/testdata/plasmidid/NO_GROUP/test/logs/plasmidID.log


No trim selected, skipping trimming step

Contigs supplied, ommiting assembly step


------------------
#Pipeline summary#
------------------
Reads R1                               NK_H22_076_1.fastq.gz
Reads R2                               NK_H22_076_2.fastq.gz
Will be mapped with ddbb               2026-01-12_plasmids.fasta
Entries covered more than              80 %
Will be clustered by                   0.5 % identity
And used to reconstruct contigs in     contigs.fasta

 STARTING KMER FILTERING, CLUSTERING and MAPPING 


SCREENING READS WITH KMERS (Wed Jan 14 12:06:04 AEDT 2026)
 Reads will be screened against database supplied for further filtering and mapping,
 this will reduce the input sequences to map against test

CLUSTERING SEQUENCES BY KMER DISTANCE (Wed Jan 14 12:13:52 AEDT 2026)
 Sequences obtained after screen will be clustered to reduce redundancy,
 one representative, the largest, will be considered for further analysis test

MAPPING READS (Wed Jan 14 12:14:14 AEDT 2026)
 Reads will be mapped against database supplied for further coverage calculation,
 this will determine the most likely plasmids in the sample test

---------------------------------------

ERROR in Script plasmidID on or near line 634; exiting with status 1
MESSAGE:

See /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/testdata/plasmidid/logs/plasmidID.log for more information.
 command:
sam_to_bam.sh -i  /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/testdata/plasmidid/NO_GROUP/test/mapping/test.sam

---------------------------------------
```

Listed log file does not exist


Found a log file elsewhere, contents:

```bash
#Executing /home/cccon/miniconda3/envs/plasmidid/bin/sam_to_bam.sh 


DEPENDENCY                    STATUS
----------                    ------
samtools                     ESC[0;32mINSTALLEDESC[0m 
Default output directory is /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/testdata/plasmidid/NO_GROUP/test/mapping
Wed Jan 14 14:18:17 AEDT 2026
Converting SAM to sorted indexed BAM in test
samtools: error while loading shared libraries: libcrypto.so.1.0.0: cannot open shared object file: No such file or directory

---------------------------------------

ESC[0;31mERRORESC[0m in Script sam_to_bam.sh on or near line 177; exiting with status 1
MESSAGE:

Samtools view command failed. See /home/cccon/Projects/PlasmidToolBenchMarking/testinstalls/testdata/plasmidid/NO_GROUP/test/mapping/logs for more information.

---------------------------------------
```

</details>

### Plasmidextractor

<details>
<summary>Install commands</summary>

```bash
conda create --name plasmidextractor
conda activate plasmidextractor
conda install -c auto pip biotools setuptools
pip install plasmidextractor
```

</details>

<details>
<summary>Run commands</summary>

```bash
PlasmidExtractor.py --help
```

</details>

<details>
<summary>Error message</summary>

```bash
DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 is no longer maintained. pip 21.0 will drop support for Python 2.7 in January 2021. More details about Python 2 support in pip, can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support
Collecting plasmidextractor
  Using cached plasmidextractor-0.2.3.tar.gz (26 kB)
Collecting biopython
  Downloading biopython-1.77.tar.gz (16.8 MB)
     |################################| 16.8 MB 48.0 MB/s 
    ERROR: Command errored out with exit status 1:
     command: /home/cccon/miniconda3/envs/plasmidextractor/bin/python2.7 -c 'import sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/cccon/pip-install-0cYEqt/biopython/setup.py'"'"'; __file__='"'"'/tmp/cccon/pip-install-0cYEqt/biopython/setup.py'"'"';f=getattr(tokenize, '"'"'open'"'"', open)(__file__);code=f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /tmp/cccon/pip-pip-egg-info-2JF9UZ
         cwd: /tmp/cccon/pip-install-0cYEqt/biopython/
    Complete output (1 lines):
    Biopython requires Python 3.6 or later. Python 2.7 detected.
    ----------------------------------------
ERROR: Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.
```

</details>

### PlasFlow

<details>
<summary>Install commands</summary>

```bash
conda create --name plasflow
conda activate plasflow
conda install python=3.5
conda install -c smaegol plasflow 
```

</details>

<details>
<summary>Run commands</summary>

```bash
PlasFlow.py --input contigs.fasta --output test
```

</details>

<details>
<summary>Error message</summary>

```bash
Traceback (most recent call last):                                                                                                                                                                                                                                                               
  File "/home/cccon/miniconda3/envs/plasflow/lib/python3.5/site-packages/numpy/core/__init__.py", line 16, in <module>                                                                                                                                                                           
    from . import multiarray                                                                                                                                                                                                                                                                     
ImportError: libgfortran.so.3: cannot open shared object file: No such file or directory                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                 
During handling of the above exception, another exception occurred:                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                 
Traceback (most recent call last):                                                                                                                                                                                                                                                               
  File "/home/cccon/miniconda3/envs/plasflow/bin/PlasFlow.py", line 45, in <module>                                                                                                                                                                                                              
    import numpy as np                                                                                                                                                                                                                                                                           
  File "/home/cccon/miniconda3/envs/plasflow/lib/python3.5/site-packages/numpy/__init__.py", line 142, in <module>                                                                                                                                                                               
    from . import add_newdocs                                                                                                                                                                                                                                                                    
  File "/home/cccon/miniconda3/envs/plasflow/lib/python3.5/site-packages/numpy/add_newdocs.py", line 13, in <module>                                                                                                                                                                             
    from numpy.lib import add_newdoc                                                                                                                                                                                                                                                             
  File "/home/cccon/miniconda3/envs/plasflow/lib/python3.5/site-packages/numpy/lib/__init__.py", line 8, in <module>                                                                                                                                                                             
    from .type_check import *                                                                                                                                                                                                                                                                    
  File "/home/cccon/miniconda3/envs/plasflow/lib/python3.5/site-packages/numpy/lib/type_check.py", line 11, in <module>                                                                                                                                                                          
    import numpy.core.numeric as _nx                                                                                                                                                                                                                                                             
  File "/home/cccon/miniconda3/envs/plasflow/lib/python3.5/site-packages/numpy/core/__init__.py", line 26, in <module>                                                                                                                                                                           
    raise ImportError(msg)                                                                                                                                                                                                                                                                       
ImportError:                                                                                                                                                                                                                                                                                     
Importing the multiarray numpy extension module failed.  Most                                                                                                                                                                                                                                    
likely you are trying to import a failed build of numpy.                                                                                                                                                                                                                                         
If you're working with a numpy git repo, try `git clean -xdf` (removes all                                                                                                                                                                                                                       
files not under version control).  Otherwise reinstall numpy.                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                 
Original error was: libgfortran.so.3: cannot open shared object file: No such file or directory  
```

Attempted re-install of Numpy but no difference

</details>

### RFPlasmid

<details>
<summary>Install commands</summary>

```bash
conda create --name rfplasmid
conda activate rfplasmid
conda install -c bioconda rfplasmid 
rfplasmid --initialize
```

</details>

<details>
<summary>Run commands</summary>

```bash
rfplasmid --species Enterobacteriaceae --input input/ --out testout
```

</details>

<details>
<summary>Error message</summary>

```bash
Start RFPlasmid, version 0.0.18
copy original contig names
cleanup contig names
start Checkm
/home/cccon/miniconda3/envs/rfplasmid/lib/python3.11/site-packages/checkm/checkmData.py:25: UserWarning: pkg_resources is deprecated as an API. See https://setuptools.pypa.io/en/latest/pkg_resources.html. The pkg_resources package is slated for removal as early as 2025-11-30. Refrain from using this package or pin to Setuptools<81.
  from pkg_resources import resource_filename
    Finished processing 1 of 1 (100.00%) bins.
    Finished parsing hits for 1 of 1 (100.00%) bins.
    Finished processing 1 of 1 (100.00%) bins.
    Finished processing 1 of 1 (100.00%) bins.
    Finished parsing hits for 1 of 1 (100.00%) bins.
Checkm done
start blast plasmiddb
/home/cccon/miniconda3/envs/rfplasmid/lib/python3.11/site-packages/RFPlasmid/rfplasmid.py:153: FutureWarning: The 'delim_whitespace' keyword in pd.read_csv is deprecated and will be removed in a future version. Use ``sep='\s+'`` instead
  df1 = pd.read_csv(f1, header=None, delim_whitespace=True, usecols=[0,2], names=['contig_gene', 'hit'])
Traceback (most recent call last):
  File "/home/cccon/miniconda3/envs/rfplasmid/lib/python3.11/site-packages/RFPlasmid/rfplasmid.py", line 157, in <module>
    df1['contig'], df1['gene'] = df1['contig_gene'].str.split('_', 1).str
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/cccon/miniconda3/envs/rfplasmid/lib/python3.11/site-packages/pandas/core/strings/accessor.py", line 140, in wrapper
    return func(self, *args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
TypeError: StringMethods.split() takes from 1 to 2 positional arguments but 3 were given
```

</details>

### PlasForest

<details>
<summary>Install commands</summary>

```bash
conda create --name plasforest
conda activate plasforest
conda install python biopython numpy pandas joblib scikit-learn==0.22.2.post1 blast
git clone https://github.com/leaemiliepradier/PlasForest
cd PlasForest/
tar -zxvf plasforest.sav.tar.gz

```

</details>

<details>
<summary>Run commands</summary>

```bash
chmod 755 database_downloader.sh
./database_downloader.sh
chmod 755 test_plasforest.sh
./test_plasforest.sh
```

</details>

<details>
<summary>Error message</summary>

```bash
Starting to test your PlasForest install...
Checking if all the files are here.... OK
We now run PlasForest on the test dataset...Traceback (most recent call last):
  File "PlasForest.py", line 27, in <module>
    from sklearn.ensemble import RandomForestClassifier
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/ensemble/__init__.py", line 7, in <module>
    from ._forest import RandomForestClassifier
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/ensemble/_forest.py", line 56, in <module>
    from ..tree import (DecisionTreeClassifier, DecisionTreeRegressor,
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/tree/__init__.py", line 6, in <module>
    from ._classes import BaseDecisionTree
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/tree/_classes.py", line 40, in <module>
    from ._criterion import Criterion
  File "sklearn/tree/_splitter.pxd", line 34, in init sklearn.tree._criterion
  File "sklearn/tree/_tree.pxd", line 37, in init sklearn.tree._splitter
  File "sklearn/neighbors/_quad_tree.pxd", line 55, in init sklearn.tree._tree
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/neighbors/__init__.py", line 17, in <module>
    from ._nca import NeighborhoodComponentsAnalysis
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/neighbors/_nca.py", line 22, in <module>
    from ..decomposition import PCA
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/decomposition/__init__.py", line 17, in <module>
    from .dict_learning import dict_learning
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/decomposition/dict_learning.py", line 4, in <module>
    from . import _dict_learning
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/decomposition/_dict_learning.py", line 21, in <module>
    from ..linear_model import Lasso, orthogonal_mp_gram, LassoLars, Lars
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/linear_model/__init__.py", line 12, in <module>
    from ._least_angle import (Lars, LassoLars, lars_path, lars_path_gram, LarsCV,
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/sklearn/linear_model/_least_angle.py", line 30, in <module>
    method='lar', copy_X=True, eps=np.finfo(np.float).eps,
  File "/home/cccon/miniconda3/envs/plasforest/lib/python3.8/site-packages/numpy/__init__.py", line 305, in __getattr__
    raise AttributeError(__former_attrs__[attr])
AttributeError: module 'numpy' has no attribute 'float'.
`np.float` was a deprecated alias for the builtin `float`. To avoid this error in existing code, use `float` by itself. Doing this will not modify any behavior and is safe. If you specifically wanted the numpy scalar type, use `np.float64` here.
The aliases was originally deprecated in NumPy 1.20; for more details and guidance see the original release note at:
    https://numpy.org/devdocs/release/1.20.0-notes.html#deprecations
```

</details>

### TaDReP

<details>
<summary>Install commands</summary>

```bash
conda create --name tadrep
conda activate tadrep
conda install -c conda-forge -c bioconda tadrep
tadrep setup
#need to download datbase
tadrep database
```

</details>

<details>
<summary>Run commands</summary>

```bash
tadrep characterize --db refseq/refseq.json 
```

</details>

<details>
<summary>Error message</summary>

```bash
Characterization started...
Traceback (most recent call last):
  File "/home/cccon/miniconda3/envs/tadrep/bin/tadrep", line 10, in <module>
    sys.exit(main())
             ~~~~^^
  File "/home/cccon/miniconda3/envs/tadrep/lib/python3.13/site-packages/tadrep/main.py", line 76, in main
    tc.characterize()
    ~~~~~~~~~~~~~~~^^
  File "/home/cccon/miniconda3/envs/tadrep/lib/python3.13/site-packages/tadrep/characterize.py", line 38, in characterize
    plasmid['cds'] = gene_prediction(plasmid['sequence'])  # gene prediction
                     ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^
  File "/home/cccon/miniconda3/envs/tadrep/lib/python3.13/site-packages/tadrep/characterize.py", line 123, in gene_prediction
    orffinder = pyrodigal.OrfFinder(meta=True, closed=True)
                ^^^^^^^^^^^^^^^^^^^
AttributeError: module 'pyrodigal' has no attribute 'OrfFinder'
```

</details>
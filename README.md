# OnlineGambling

How to check the code:

1. I'm still working on the introduction and the general discussion of the paper, but the method and results are more or less ready. It should provide you with some context for the analysis code.

2. The raw csv files can be downloaded from https://osf.io/67dyh/?view_only=85171f3cbb20414f8951dde753c7b53a

3. After downloading the two zip files, you can unzip them into the `data` folder. I have one folder within the `data` folder called `data_addict_players` (contains all data from the addicted players) and another called `data_non_addict_players` (contains all data from the non-addicted players). This is where the code expects to find the raw data files.

4. The analysis code can be found in the `code/analysis` folder. I divided the code into several R/Rmd files to (hopefully) increase the readability of the code. You will see a lot of other files, but only the R and Rmd files are relevant (the rest is from bookdown to build websites; more on this below).

5. The first file you'll need is `00-data_preparation.R`. This file takes the raw csv files from each player and combine them into two big RData files, one containing all data from the addicted players, and one containing all data from the non-addicted players. These two RData files will be saved in the `data/processed` folder. Note: this process will take time (there are probably more efficient ways to do it, but I'm a bit reluctant to change anything now - unless, of course, there are errors in there). Note that the raw csv files and these two RData files will **not** be shared (they are property of the gaming company and we cannot share them). But it would still be good if you can check this file, to make sure there's no error in the first step.

6. The analysis code is in the numbered Rmarkdown files, from `01-settings.Rmd` till `07-trial_counts.Rmd`. The `02-proecess_data.Rmd` file takes the two RData files generated above and create some summary data in multiple csv files. The later analysis is based on these csv files (will be saved in the `data/processed` folder). We hope to share these summary csv files later on, but still need to get the approval from the company.

7. I was playing around with bookdown when started working on this project (that's why there are all these extra files). With bookdown, you can turn the Rmd files into a git-book style website. I have done that, and the output is saved in the `docs` folder. If you open the `index.html` file, you can see all code and results with web browsers. These files can be hosted on github later on, which can be a cool way to share the code and analysis results I think.

8. That's everything I think! Thanks a lot!

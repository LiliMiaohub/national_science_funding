Cooperation and interdependence in global science funding

**Authors:** Miao, Lili, Vincent Larivière, Feifei Wang, Yong-Yeol Ahn, and Cassidy R. Sugimoto

# Reproducing:

Load the provided conda environment, provided in `funding.yml`, using the command `conda env create -f funding.yml`. Then be sure to activate this environment in your working directory using `conda activate myenv`. To install additional modules in the source code, utilize pip to install the package located in the "libs" folder.


You can download the simulated data for this analysis at [here](https://figshare.com/articles/dataset/Cooperation_and_interdependence_in_global_science_funding/25270075). The simulated data comprises 5% of publications used in our analysis, with randomized paper IDs, authorship affiliation countries and randomized funding countries. It is important to note that the simulated dataset is not suitable for reproducing the results presented in the paper; its purpose is solely to validate the source code. For access to the Web of Science dataset used in the main analysis, readers are encouraged to contact Thomson Reuters through the following [URL](http://thomsonreuters.com/en/products-services/scholarly-scientific-research/scholarly-search-and-discovery/web-of-science.html).

Please follow these steps to test the validity of the source code:
1. create a root folder for the project, for example `/Dropbox/national_funding/`.
2. Under the root folder, create two subfolders named `Data` and `Figs` to store the data and figures, respectively.
3. Within the `Data` folder, create three additional subfolders:`AdditionalData`, `DerivedData`, and `RawData`. Place the uncompressed AdditionalData dataset in the `AdditionalData` folder and place the uncompressed RawData dataset in the `RawData` folder.
4. Update the root directory in the config.yaml file and run the `snakemake` command. You can find more information about running snakemake in [the wiki](https://github.com/murrayds/sci-mobility-emb/wiki/Snakemake). This will produce the final figures and all intermediary data used in the research project. As much data as possible has been provided to speed up this process, but it will take some time.

# Requirements
1. Install [node](https://nodejs.org/en)
2. Install [i18next-parser](https://github.com/i18next/i18next-parser):
```
yarn global add i18next-parser
npm install -g i18next-parser
```

# Usage

1. Clone this repository and cd to it
2. Switch to feature branch in repository you want to scan (stash or commit all changes)
3. Execute script - diff will be saved in the folder where shript is located (i18ndiff.json) and displayed in your terminal:
```
./diff_i18n_keys.sh --path /path/to/project/root --pattern "packages/web/**/*.tsx" --outPath ~/i18dndiff --compareWithBranch master
```


## Options
<table>
<thead>
<tr>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tr>
<td>--path</td>
<td>Path to the root of your project repository you wish to scan</td>
</tr>
<tr>
<td>--pattern</td>
<td>Pattern of files that should be scanned, can be glob</td>
</tr>
<tr>
<td>--outPath</td>
<td>Path to the folder where residuary output files will be created</td>
</tr>
<tr>
<td>--compareWithBranch</td>
<td>Name of the git branch to compare with</td>
</tr>
</table>




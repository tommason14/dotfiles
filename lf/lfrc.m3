# Shell opts {{{1

# NB: $ = shell command, ! = shell command and wait for user to enter
# $f = current file

set shell sh
set shellopts '-eu'
set ifs "\n"

# Settings {{{1

set info size
set icons
set drawbox
set previewer ~/dotfiles/lf/previewer.sh

# Custom commands {{{1

# LF commands {{{2

cmd q quit
cmd touch $touch $1
cmd mkdir $mkdir -p $1
cmd mv $mv "$f" $1

cmd pymol ${{
  eval "/Applications/PyMOL.app/Contents/MacOS/PyMOL $@ -d "@~/.pymolrc""
}}

cmd chem_assist_ds ${{
  settings_file=$(ls *.py | sort | head -n 1)
  chem_assist -ds $settings_file
  [ -d __pycache__ ] && rm -r __pycache__
}}

cmd bulk-rename ${{ # {{{3
	index=$(mktemp /tmp/lf-bulk-rename-index.XXXXXXXXXX)
	if [ -n "${fs}" ]; then
		echo "$fs" > $index
	else
		echo "$(ls "$(dirname $f)" | tr ' ' "\n")" > $index
	fi
	index_edit=$(mktemp /tmp/lf-bulk-rename.XXXXXXXXXX)
  # basenames not the whole path
  awk -F "/" '{print $NF}' $index > tmpf && mv tmpf $index
	cat $index > $index_edit
	$EDITOR $index_edit
	if [ $(cat $index | wc -l) -eq $(cat $index_edit | wc -l) ]; then
		max=$(($(cat $index | wc -l)+1))
		counter=1
		while [ $counter -le $max ]; do
			a="$(cat $index | sed "${counter}q;d")"
			b="$(cat $index_edit | sed "${counter}q;d")"
			counter=$(($counter+1))
			
			[ "$a" = "$b" ] && continue
			[ -e "$b" ] && echo "File exists: $b" && continue
			mv "$a" "$b"
		done
	else
		echo "Number of lines must stay the same"
	fi
	rm $index $index_edit
}}

# Mappings {{{1

# Remove defaults {{{2 

map c
map d
map l
map m
map p
map r
map w
map y

# Ranger-like {{{2

map yy copy
map dd cut
map pp paste
map dD $mv "$fx" ~/.Trash/ 
map dt delete # delete true
map <bs2> set hidden!
map re rename
cmap <esc> cmd-escape

# File opening {{{2

map o. $open .
map oiv $vim -p $fx
map om $molden "$f"
map og $gmolden "$f"
map oav $open -a /Applications/Avogadro.app/ "$f"
map oia $open -a /Applications/iA\ Writer.app/ "$f"
map oiq $open -a /Applications/iQmol.app/ "$f"

cmd vmd ${{

# load vmdlammps.sh if lammps file
grep -Fq "atoms" $f && vmdlammps.sh $(basename $f) && exit 0

if [ $USER == "tmas0023" ]
then
  /Applications/VMD\ 1.9.3.app/Contents/vmd/vmd_MACOSXX86 "$f"
elif [ $USER == "tommason" ]
then
  /Applications/VMD\ 1.9.4a38.app/Contents/vmd/vmd_MACOSXX86_64 "$f"
else
  vmd "$f"
fi
}}
map ou push $use<space>
map ovm vmd "$f"
map ovi $use ovito "$(basename $f)"
map op pymol "$fs"
map ors $open -a /Applications/RStudio.app/ "$f"
map otx $open -a /Applications/texstudio.app/ "$f"
map <enter> $open "$f" # default programs
map pr $qlmanage -p "$f" &>/dev/null
map os $use skim "$f"
map oz $zathura "$f"
map ovl $"$(find /usr/local/Cellar/vim -name 'less.sh')" "$f"

cmd open ${{
    case $(file --mime-type $f -b) in
        application/pdf|image/*) 
          for f in $fx
          do 
            qlmanage -p "$f" &> /dev/null
          done 
          ;;
        text/*) $EDITOR $fx;;
        *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
    esac
}}


# Shell utilities {{{2

map . ${{lf -remote "send $id push $./$(basename $f)<space>"}}
map g2m $gamess_to_molden.py "$f"
map moc $molden2csv "$f"
map mx $chmod +x "$f"
map yc $cat "$f" | pbcopy
map p2 !python $f
map py !python3 $f
map rot $remove_orca_temps
map gfr !gauss_freqs
map cl !compile_latex $(basename "$f")
map md push :mkdir<space>
map rs $Rscript $f
map tr $travis_xyz_analysis "$f"
map tdr $travis_xyz_analysis "$f" drude
map rl !realpath "$f" 
map pt $polymatic_types.py $(basename "$f") > types.txt

# utilities
cmap <C-c> cmd-escape

map yq1 $yes "" | qcp -t1
map yq2 !qcp -t2
map yq3 $yes "" | qcp -t3

map cad chem_assist_ds
map cae $chem_assist -e
map car $chem_assist -r
map cat :chem_assist -t -m 1

# fluorescence
map yqf $qcp_fluorescence
map yqfa $qcp_fluorescence_all
# defaults
map pfd $/Volumes/GoogleDrive/My\ Drive/scripts/fluorescence/plot_uv_vis_last_iter.py -f "$f"
map pfn $/Volumes/GoogleDrive/My\ Drive/scripts/fluorescence/plot.gnuplot.sh "$f"
# trimmed
map pft $/Volumes/GoogleDrive/My\ Drive/scripts/fluorescence/plot_uv_vis_last_iter.py -f "$f" -l 180 -m 500

# Gnuplots {{{2

map pm !plotmp2 "$f"
map pfo !plotfmo "$f"
map pga !plotgauss "$f"
map pgr !plotrmsgamess "$f"

# New files {{{2

# templates
cmd new_rmd %{{
  cp ~/Documents/repos/templates/template.rmd $1
  sed -i "" "s/Title/${@:2}/" $1
}}

# map tr push :new_rmd<space>
map mr !Rscript -e "require(rmarkdown); render(\"$f\")"

# Renaming {{{2

map br bulk-rename "$fs"

map I :{{
  rename
  cmd-home
}}

map A rename 

# Wallpaper {{{2

map wl $~/Documents/repos/wallpapers/make_wallpaper.sh "$f" 
map lwl $~/Documents/repos/wallpapers/make_wallpaper.sh "$f" -l
map wr $~/Documents/repos/wallpapers/random_wallpaper.sh
map lwr $~/Documents/repos/wallpapers/random_wallpaper.sh -l


# Copy across volumes, say from google drive to local mac


# Store all copied 
cmd myc !{{
echo $fs #  ↓ replacing space in string   ↓ add newline to count
echo $fs | sed -E 's/ [A-z]/\\&/' | sed 's; /;\n&;g' 
# export COPIED=$fs
}}

# SLURM {{{2

map sb $sbatch "$f"
map sj $submit_jobs
map squ !squeue -u $USER -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D %R"
map sql !squeue -u $USER -o "%.10i %.50Z %.10P %.15j %.8u %8Q %.8T %.10M %.4C %.12l %.12L %.6D %.16S %R"
map sqo !squeue -u $USER -o "%10i %30j %130Z"

# Files {{{2

map oba $vim ~/dotfiles/aliases/aliases.base && cd ~/dotfiles/shortcuts && ./make_shortcuts.sh && source ~/.bashrc; cd - > /dev/null
map obf $vim ~/.bash_functions; [[ ! $USER =~ (tmas0023|tommason) ]] && source ~/.bashrc
map obp $vim ~/.bash_profile; [[ ! $USER =~ (tmas0023|tommason) ]] && source ~/.bashrc
map obr $vim ~/.bashrc; [[ ! $USER =~ (tmas0023|tommason) ]] && source ~/.bashrc
map oip $vim ~/dotfiles/jupyter/ipythonrc
map orp $vim ~/dotfiles/Rprofile
map otdc $vim ~/Documents/repos/daily_log/choline.md
map otdd $vim ~/Documents/repos/daily_log/dopamine.md
map otdj $vim ~/Documents/repos/daily_log/subd_jobs.md
map otdm $vim ~/Documents/repos/daily_log/membranes.md
map otdp $vim ~/Documents/repos/daily_log/membranes.md
map ovrc $vim ~/dotfiles/vimrc
map ozh $vim ~/.zshrc && source ~/.zshrc

# Movement {{{2

map gau cd ~/monash_automation/
map gch cd /home/tmason1/sn29_scratch/tmason1/hydrated_ils
map gcs cd ~/chem_scripts
map gd cd /home/tmason1/sn29_scratch/tmason1/dopamine
map gdf cd ~/dotfiles
map gp cd /home/tmason1/sn29_scratch/tmason1/polymers
map gq cd /home/tmason1/sn29/apps/qcp
map gs cd /home/tmason1/sn29_scratch/tmason1
map gsc cd ~/.local/scripts
map gt cd /home/tmason1/sn29_scratch/tmason1/tests
map gw cd /home/tmason1/sn29

# Shell opts {{{1

# NB: $ = shell command, ! = shell command and wait for user to enter
# $f = current file

set shell sh
set shellopts '-eu'
set ifs "\n"

# Settings {{{1

set info size
set previewer ~/dotfiles/lf/previewer.sh


# Custom commands {{{1

# LF commands {{{2

cmd q quit
cmd touch $touch $1
cmd mkdir $mkdir -p $1
cmd mv $mv "$f" $1

cmd bulk-rename ${{ # {{{3
	index=$(mktemp /tmp/lf-bulk-rename-index.XXXXXXXXXX)
	if [ -n "${fs}" ]; then
		echo "$fs" > $index
	else
		echo "$(ls "$(dirname $f)" | tr ' ' "\n")" > $index
	fi
	index_edit=$(mktemp /tmp/lf-bulk-rename.XXXXXXXXXX)
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

cmd open-file ${{ # {{{3
  file -i $f | grep -q 'text\|regular' && vim $f || open $f
  # case $f in
  #   *.md|*.txt|*.py|*.js|*.sh|*.yaml|*.f|*.src|*.cpp|*.c|*.) vim $f;;
  #   *.png|*.jpg) open $f;;
  #   *.tar.xz|*.txz) tar xJvf $f;;
  #   *.zip) unzip $f;;
  #   *.rar) unrar x $f;;
  #   *.7z) 7z x $f;;
  # esac
}}

# Gnuplots {{{2

cmd plotmp2 !{{ 
   cat "$f" |\
   grep 'E(MP2)' |\
   sed '/NaN/d' |\
   tr -s [:blank:] |\
   cut -d ' ' -f 3 |\
   gnuplot -e "set terminal dumb; plot '-' with lines notitle"
}}

cmd plotfmo !{{
  cat "$f" |\
  grep 'E corr MP2(2)=' |\
  tr -s [:blank:] |\
  cut -d ' ' -f 10 |\
  gnuplot -e "set terminal dumb; plot '-' with lines notitle"
}}

cmd plotgauss !{{
  cat "$f" |\
  grep 'SCF Done' |\
  tr -s [:blank:] |\
  cut -d ' ' -f 6 |\
  gnuplot -e "set terminal dumb; plot '-' with lines notitle"
}}

# Mappings {{{1

# Remove defaults {{{2 

map d
map m
map p
map y

# Ranger-like {{{2

map yy copy
map dd cut
map pp paste
map dD delete
map dt $mv "$fx" ~/.trash # bin for accidental deletion
map <bs2> set hidden!
cmap <esc> cmd-escape

# File opening {{{2

map o. $open .
map ov $vim "$f"
map om $molden "$f"
map og $gmolden "$f"
map oi $open -a /Applications/iA\ Writer.app/ "$f"
map <enter> $open "$f" # default programs

# dedicated keys for file opener actions
# map o &rifle $f
# map O $mimeopen --ask $f

# define a custom 'open' command
# This command is called when current file is not a directory. You may want to
# use either file extensions and/or mime types here. Below uses an editor for
# text files and a file opener for the rest.
cmd open ${{
    case $(file --mime-type $f -b) in
        text/*) $EDITOR $fx;;
        *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
    esac
}}


# Shell utilities {{{2

map g2m $gamess_to_molden.py "$f"
map mx $chmod +x "$f"
map yc $cat "$f" | pbcopy

# utilities
cmap <C-c> cmd-escape

map yq1 $yes "" | qcp -t1
map yq2 !qcp -t2
map yq3 $yes "" | qcp -t3

# fluorescence
map yqf $qcp_fluorescence
map yqfa $qcp_fluorescence_all
# defaults
map pfd $/Volumes/GoogleDrive/My\ Drive/scripts/fluorescence/plot_uv_vis_last_iter.py -f "$f"
map pfn $/Volumes/GoogleDrive/My\ Drive/scripts/fluorescence/plot.gnuplot.sh "$f"
# trimmed
map pft $/Volumes/GoogleDrive/My\ Drive/scripts/fluorescence/plot_uv_vis_last_iter.py -f "$f" -l 180 -m 500

# Gnuplots {{{2

map pm plotmp2 "$f"
map pfo plotfmo "$f"
map pg plotgauss "$f"

# New files {{{2

# templates
cmd new_rmd %{{
  cp ~/Documents/repos/templates/template.rmd $1
  sed -i "" "s/Title/${@:2}/" $1
}}

map tr push :new_rmd<space>
map mr $Rscript -e "require(rmarkdown); render(\"$f\")"

# Renaming {{{2

map br bulk-rename "$fs"

map I :{{
  rename
  cmd-home
}}

map A rename 

# SLURM {{{2

map sb $sbatch "$f"
map sq !squeue -u tmason1
map qu !squeue -u tmason1 -o "%.18i %.9P %.30j %.8u %.2t %.10M %.6D"
map ql !squeue -u tmason1 -o "%.10i %.50Z %.10P %.15j %.8u %8Q %.8T %.10M %.4C
%.12l %.12L %.6D %.16S %R"
map qo !squeue -u tmason1 -o "%10i %30j %130Z"

# Files {{{2

map oba $vim ~/.bash_aliases && source ~/.bashrc
map obf $vim ~/.bash_functions && source ~/.bashrc
map obp $vim ~/.bash_profile && source ~/.bashrc
map obr $vim ~/.bashrc && source ~/.bashrc
map oip $vim ~/dotfiles/jupyter/ipythonrc
map orp $vim ~/dotfiles/Rprofile
map ov $vim ~/dotfiles/vimrc

# Movement {{{2

map ga cd ~/monash_automation/
map gc cd /home/tmason1/sn29_scratch/tmason1/hydrated_ils
map gq cd /home/tmason1/sn29/apps/qcp
map gs cd /home/tmason1/sn29_scratch/tmason1
map gw cd /home/tmason1/sn29

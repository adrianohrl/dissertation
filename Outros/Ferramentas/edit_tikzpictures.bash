
USAGE="Usage: edit_tikzpictures [--directory | -d <root directory>]
                                [--help | -h] 
                                [--verbose | -v] 

  Author: Adriano Henrique Rossette Leite
  Version: 1.0.0
  Description: This script, recursivily, exports all Dia Diagram 
               Editor files to PGF files (with .tex extensions)
               replaces '\_' by '_', '\ $' by '$' in .tex files 
               generated during the PGF file exporter of Dia 
               Diagram Editor.

  Options:

    -d, --directory <root directory>
         Informs the desired root directory.
    -h, --help
         Shows this helper message for usage info.

"  

if [[ ${#} = 0 ]]; then
  echo "${USAGE}"
  exit
fi

DIRECTORY=""
VERBOSE=false
while [[ ${#} -gt 0 ]]; do
	case "${1}" in
      -d|--directory)
        DIRECTORY="${2}"
        shift
        ;;
      -v|--verbose)
        VERBOSE=true
        ;;
	    -h|--help)
			echo "${USAGE}"
			exit
		    ;;
	    *)
		    ;;
	esac
	shift
done

if [[ ! -d ${DIRECTORY} ]]; then
  echo "ERROR: ${DIRECTORY} directory does not exist!!!"
  echo "Aborting ..."
  exit 
fi

PATTERNS='s/\\_/_/g; s/\\\$/$/g;'
if [[ ${VERBOSE} = true ]]; then
  echo "DIRECTORY = ${DIRECTORY}"
  echo "PATTERNS  = ${PATTERNS}"
fi

find ${DIRECTORY} -name "*.dia" -print | while read DIA_FILE; do
  TEX_FILE=${DIA_FILE%.dia}.tex
  if [[ ${VERBOSE} = true ]]; then
    echo "Exporting ${TEX_FILE}, based on ${DIA_FILE} ..."
  fi
  dia -e ${TEX_FILE} -t pgf-tex ${DIA_FILE}
  if [[ ! -f ${TEX_FILE} ]]; then
    echo "Unable to export ${TEX_FILE}"
  else
    if [[ ${VERBOSE} = true ]]; then
      echo "Replacing patterns in ${TEX_FILE} ..."
    fi
    sed -i "${PATTERNS}" ${TEX_FILE}
  fi
done

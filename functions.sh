function link_data() {
	for dir in "${1}"/*; do
		target_dir="${2}/$(basename "${dir}")";
		mkdir -pv "${target_dir}";
		for file in "${dir}"/*; do
			if [ ! -f "${target_dir}/$(basename "${file}")" ]; then
				echo "--- Linking in ${file}";
				ln -svf "${file}" "${target_dir}/";
			fi;
		done;
	done;
}

function overwrite_default_file() {
	file="${1}";
	shift;
	sample_file="${1}";
	shift;
	if [ ! -f "${file}" ]; then
		echo "--- '${file}' not found; using '${sample_file}' with env overrides"
		cp -avf "${sample_file}" "${file}";
		for var in $*; do
			# Explanation of syntaxes:
			#    ${!var} means "use the value of the variable whose name is the value of $var"
			#    ${var+x} is a substitution useful in a [ -z ] conditional to make sure a variable is set; just using ${var} would also trigger on empty but set variables
			#    ${!var+x} puts them together; it takes the value of the variable whose name is the value of $var, and does the same substitution on it for a [ -z ] conditional.
			echo ">>> ${var} = ${!var}";
			if [ -z "${!var+x}" ]; then
				echo "!!! \${${var}} not set";
				exit 1;
			fi;
		done;
	else
		echo "--- '${file}' found; overrides are optional"
	fi;
}

function copy_in_vars() {
	file="${1}";
	shift;
	for var in $*; do
		value="$(echo "${var}" | sed 's/[\/&]/\\&/g')";
		sed -i --follow-symlinks "s/%${var}%/${value}/g" "${file}";
	done;
}


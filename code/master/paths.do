/*==============================================================================
    paths.do — Central path configuration

    Run this at the start of every do-file:
        do "$RB/code/master/paths.do"

    Or set $RB as a system environment variable and run:
        do "${RB}/code/master/paths.do"
==============================================================================*/

* --- PROJECT ROOT (edit this one line for your machine) ---
global RB "{{path/to/quarto/project/root}}"

* --- OVERLEAF (edit this one line for your machine) ---
global OL "{{path/to/Overleaf/project}}"

* --- DERIVED PATHS (do not edit) ---
global DATA     "$RB/data_final"
global DATA_RAW "$RB/data_raw"
global OUTPUT   "$RB/output"
global RESULTS  "$RB/output/results"
global CODE     "$RB/code"
global TABLES   "$OL/files/tab"
global FIGURES  "$OL/files/fig"

* --- VERIFY ---
capture confirm file "$RB/_quarto.yml"
if _rc {
    di as error "WARNING: Cannot find _quarto.yml at $RB — check paths.do"
}
else {
    di as text "Paths loaded. RB = $RB"
}

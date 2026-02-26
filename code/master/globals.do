/*==============================================================================
    globals.do — Project-specific analysis globals

    Run after paths.do:
        do "$RB/code/master/paths.do"
        do "$RB/code/master/globals.do"
==============================================================================*/

* --- TABLE OUTPUT SUBFOLDER ---
* All esttab tables go to $TABLES/$TABLE_SUB/
global TABLE_SUB "{{your_subfolder}}"

* --- PANEL DEFINITIONS ---
* global PANEL_A "$DATA/{{panel_a_filename}}.dta"
* global PANEL_B "$DATA/{{panel_b_filename}}.dta"

* --- SAMPLE RESTRICTIONS ---
* global SAMPLE_RESTRICT "& year != 2020 & year != 2021"    // example: COVID exclusion

* --- CLUSTERING ---
* global CLUSTER "cluster(county_id)"                        // example: county-clustered SEs

* --- TREATMENT VARIABLE ---
* global TREAT "treatment_indicator"                         // example: your treatment var

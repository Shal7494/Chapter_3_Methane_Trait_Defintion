#!/usr/bin/env bash
# 01_02_create_all_as.sh
#
# Creates all ASReml .as files required for the analysis:
#
#   Regular univariate:
#     uEBV_bw
#     uEBV_dch4
#     uEBV_dco2
#
#   Regular multivariate:
#     mEBV_base
#
#   Residual univariate:
#     uEBV_r1
#     uEBV_r2
#     uEBV_r3
#
#   Residual multivariate:
#     mEBV_r1
#     mEBV_r2
#     mEBV_r3
#
# 10 analyses x 180 simulations = 1800 .as files

set -Eeuo pipefail


# ============================================================
# SETTINGS
# ============================================================

# Directory in which this script is located.
# By default, .as files are created in the same directory.
# Alternatively, a different output directory can be supplied
# as the first command-line argument.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="${1:-$SCRIPT_DIR}"

LOW=1
HIGH=180

mkdir -p "$DIR"

echo "Output directory: $DIR"

# ============================================================
# CREATE FILES
# ============================================================

for i in $(seq "$LOW" "$HIGH"); do

  echo "============================================================"
  echo "Creating .as files for simulation ${i}"
  echo "============================================================"


  # ==========================================================
  # 1. BODY WEIGHT - UNIVARIATE EBV
  # ==========================================================

  sed "s/__I__/${i}/g" > "${DIR}/uEBV_bw_s${i}.as" <<'TPL'
uEBV bw s__I__
 id      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped___I__.ped !MAKE
full_sim___I__.csv !skip 1 !maxit 20 !typeIII

bw_p ~ mu sex yob dam_par litter_size !r id

VPREDICT ! DEFINE
F phen 1 2
H herit 1 3
TPL


  # ==========================================================
  # 2. DAILY METHANE - UNIVARIATE EBV
  # ==========================================================

  sed "s/__I__/${i}/g" > "${DIR}/uEBV_dch4_s${i}.as" <<'TPL'
uEBV dch4 s__I__
 id      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped___I__.ped !MAKE
full_sim___I__.csv !skip 1 !maxit 20 !typeIII

ch4_p_x ~ mu sex yob dam_par litter_size !r id

VPREDICT ! DEFINE
F phen 1 2
H herit 1 3
TPL


  # ==========================================================
  # 3. DAILY CARBON DIOXIDE - UNIVARIATE EBV
  # ==========================================================

  sed "s/__I__/${i}/g" > "${DIR}/uEBV_dco2_s${i}.as" <<'TPL'
uEBV dco2 s__I__
 id      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped___I__.ped !MAKE
full_sim___I__.csv !skip 1 !maxit 20 !typeIII

co2_p_x ~ mu sex yob dam_par litter_size !r id

VPREDICT ! DEFINE
F phen 1 2
H herit 1 3
TPL


  # ==========================================================
  # 4. BASE - MULTIVARIATE EBV
  # ==========================================================

  sed "s/__I__/${i}/g" > "${DIR}/mEBV_base_s${i}.as" <<'TPL'
mEBV base s__I__
 ani      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped___I__.ped !MAKE
full_sim___I__.csv !skip 1 !maxit 200000 !typeIII

bw_p ch4_p_x co2_p_x ~ Trait Tr.sex Tr.yob Tr.dam_par Tr.litter_size !r Tr.ani

1 2 1
0
Tr 0 us 44.0688
24.5816 50.4569
16.8299 22.6518 18.3396 !gp
Tr.ani 2
Tr 0 us 26.3160
9.88278 15.8705
6.86522 9.96541 6.81045 !gp
ani

!VPREDICT !DEFINE
P pvar1 1 7
P pvar2 3 9
P pvar3 6 12
P pcov12 2 8
P pcov13 4 10
P pcov23 5 11
H ani_h1 7 13
H ani_h2 9 14
H ani_h3 12 15
R ecorr12 1 2 3
R ecorr13 1 4 6
R ecorr23 3 5 6
R gcorr12 7 8 9
R gcorr13 7 10 12
R gcorr23 9 11 12
R pcorr12 13 16 14
R pcorr13 13 17 15
R pcorr23 14 18 15
TPL


  # ==========================================================
  # 5. RESIDUAL 1 - UNIVARIATE EBV
  # ==========================================================

  sed "s/__I__/${i}/g" > "${DIR}/uEBV_r1_s${i}.as" <<'TPL'
uEBV r1 s__I__
 id      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped___I__.ped !MAKE
full_sim___I__.csv !skip 1 !maxit 20000 !typeIII

res_1 ~ mu !r id

VPREDICT ! DEFINE
F phen 1 2
H herit 1 3
TPL


  # ==========================================================
  # 6. RESIDUAL 2 - UNIVARIATE EBV
  # ==========================================================

  sed "s/__I__/${i}/g" > "${DIR}/uEBV_r2_s${i}.as" <<'TPL'
uEBV r2 s__I__
 id      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped___I__.ped !MAKE
full_sim___I__.csv !skip 1 !maxit 20000 !typeIII

res_2 ~ mu !r id

VPREDICT ! DEFINE
F phen 1 2
H herit 1 3
TPL


  # ==========================================================
  # 7. RESIDUAL 3 - UNIVARIATE EBV
  # ==========================================================

  sed "s/__I__/${i}/g" > "${DIR}/uEBV_r3_s${i}.as" <<'TPL'
uEBV r3 s__I__
 id      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped___I__.ped !MAKE
full_sim___I__.csv !skip 1 !maxit 20000 !typeIII

res_3 ~ mu !r id

VPREDICT ! DEFINE
F phen 1 2
H herit 1 3
TPL


  # ==========================================================
  # 8-10. RESIDUALS 1-3 - MULTIVARIATE EBVs
  # ==========================================================

  for res in 1 2 3; do

    # Different starting values are required for residual 1
    # compared with residuals 2 and 3.

    if [[ "$res" == "1" ]]; then

      RESIDUAL_START='Tr 0 us !GP 75.0
28.0 49.6
45.0 30.0 51.0'

      GENETIC_START='Tr.ani 2
Tr 0 us !GP 450.0
-120.0 135.0
20.0 -25.0 35.0
ani'

    else

      RESIDUAL_START='Tr 0 us !GP 24.2608
24.4811 42.9989
0.0 27.1915 54.6702'

      GENETIC_START='Tr.ani 2
Tr 0 us !GP 316.900
-246.382 264.294
0.0 18.9778 21.8389
ani'

    fi


    OUTFILE="${DIR}/mEBV_r${res}_s${i}.as"

    cat > "$OUTFILE" <<EOF
mEBV r${res} s${i}
 ani      !P
 sire    !A
 dam     !A
 sex     !A
 dob     !A
 jul_dob !I
 yob     !I
 dam_par !I
 litter_size !I
 surv_2018
 surv_2019
 surv_2020
 surv_2021
 surv_2022
 surv_2023
 bw_tbv
 fi_tbv
 ch4_tbv
 co2_tbv
 ych4_tbv
 yco2_tbv
 bw_p
 fi_p
 ch4_p
 co2_p
 ych4_p
 yco2_p
 ch4_p_x
 co2_p_x !/100
 res_1
 res_2
 res_3
 dummy 1

all_ped_${i}.ped !MAKE
full_sim_${i}.csv !skip 1 !maxit 20000000 !MVINCLUDE !typeIII

res_${res} bw_p co2_p_x ~ Trait at(Tr,2).sex at(Tr,2).yob at(Tr,2).dam_par at(Tr,2).litter_size at(Tr,3).sex at(Tr,3).yob at(Tr,3).dam_par at(Tr,3).litter_size !r Tr.ani

1 2 1
0
${RESIDUAL_START}
${GENETIC_START}

!VPREDICT !DEFINE
P pvar1 1 7
P pvar2 3 9
P pvar3 6 12
P pcov12 2 8
P pcov13 4 10
P pcov23 5 11
H ani_h1 7 13
H ani_h2 9 14
H ani_h3 12 15
R ecorr12 1 2 3
R ecorr13 1 4 6
R ecorr23 3 5 6
R gcorr12 7 8 9
R gcorr13 7 10 12
R gcorr23 9 11 12
R pcorr12 13 16 14
R pcorr13 13 17 15
R pcorr23 14 18 15
EOF

  done


  # ==========================================================
  # SIMULATION COMPLETE
  # ==========================================================

  echo "Created 10 .as files for simulation ${i}"
  echo

done


# ============================================================
# CHECK ALL EXPECTED FILES WERE CREATED
# ============================================================

echo
echo "============================================================"
echo "CHECKING CREATED .as FILES"
echo "============================================================"

declare -a STEMS=(
  "uEBV_bw"
  "uEBV_dch4"
  "uEBV_dco2"
  "mEBV_base"
  "uEBV_r1"
  "uEBV_r2"
  "uEBV_r3"
  "mEBV_r1"
  "mEBV_r2"
  "mEBV_r3"
)

expected_total=$(( ${#STEMS[@]} * (HIGH - LOW + 1) ))

found_total=0
missing_total=0


for stem in "${STEMS[@]}"; do

  for ((i=LOW; i<=HIGH; i++)); do

    file="${DIR}/${stem}_s${i}.as"

    if [[ -f "$file" ]]; then

      ((found_total+=1))

    else

      ((missing_total+=1))
      echo "MISSING: ${stem}_s${i}.as"

    fi

  done

done


# ============================================================
# FINAL SUMMARY
# ============================================================

echo
echo "============================================================"
echo "FINAL SUMMARY"
echo "============================================================"
echo "Expected .as files: $expected_total"
echo "Found .as files:    $found_total"
echo "Missing .as files:  $missing_total"
echo "============================================================"


if (( missing_total == 0 )); then

  echo
  echo "SUCCESS — all $expected_total .as files were created."

else

  echo
  echo "ERROR — $missing_total expected .as files are missing."
  exit 1

fi

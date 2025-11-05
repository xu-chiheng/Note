#!/bin/bash -i

cd "$(dirname "$0")"


SOURCE_INSIGHT_3_5_DIR='D:\Documents\Source Insight'
SOURCE_INSIGHT_4_0_DIR='D:\Documents\Source Insight 4.0'

SOURCE_INSIGHT_3_5_C_TOM="$(cygpath -u "${SOURCE_INSIGHT_3_5_DIR}")/C.tom"
SOURCE_INSIGHT_4_0_C_TOM="$(cygpath -u "${SOURCE_INSIGHT_4_0_DIR}")/C.tom"

echo "${SOURCE_INSIGHT_3_5_C_TOM}"
echo "${SOURCE_INSIGHT_4_0_C_TOM}"

if ! [ -f "${SOURCE_INSIGHT_3_5_C_TOM}.orig" ]; then
    echo_command mv "${SOURCE_INSIGHT_3_5_C_TOM}" "${SOURCE_INSIGHT_3_5_C_TOM}.orig"
fi

if ! [ -f "${SOURCE_INSIGHT_4_0_C_TOM}.orig" ]; then
    echo_command mv "${SOURCE_INSIGHT_4_0_C_TOM}" "${SOURCE_INSIGHT_4_0_C_TOM}.orig"
fi

echo_command cp -f "${SOURCE_INSIGHT_3_5_C_TOM}.orig" "${SOURCE_INSIGHT_3_5_C_TOM}"
echo_command cat C.tom >>"${SOURCE_INSIGHT_3_5_C_TOM}"

echo_command cp -f "${SOURCE_INSIGHT_4_0_C_TOM}.orig" "${SOURCE_INSIGHT_4_0_C_TOM}"
echo_command cat C.tom >>"${SOURCE_INSIGHT_4_0_C_TOM}"

echo_command sync "$(cygpath -u "${SOURCE_INSIGHT_3_5_DIR}")" "$(cygpath -u "${SOURCE_INSIGHT_4_0_DIR}")"

echo "Completed"
read

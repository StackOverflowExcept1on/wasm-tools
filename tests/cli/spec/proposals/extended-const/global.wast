;; RUN: wast \
;;      --assert default \
;;      --assert permissive \
;;      --snapshot tests/snapshots \
;;      --ignore-error-messages \
;;      --features=wasm2,extended-const \
;;      tests/testsuite/proposals/extended-const/global.wast

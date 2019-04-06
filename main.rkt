#lang racket

; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide tat-bak
         tat-bak-from-pretransfer-to-biltrans
         tat-bak-from-t1x-to-postgen
         tat-bak)

(require pkg/lib
         rackunit
         rash
         apertiumpp/streamparser)

(define (symbol-append s1 s2)
  (string->symbol (string-append (symbol->string s1) (symbol->string s2))))

(define A-TAT-BAK './)
(define A-TAT-BAK-BIL (symbol-append A-TAT-BAK 'tat-bak.autobil.bin))
(define A-TAT-BAK-T1X (symbol-append A-TAT-BAK 'apertium-tat-bak.tat-bak.t1x))
(define A-TAT-BAK-T1X-BIN (symbol-append A-TAT-BAK 'tat-bak.t1x.bin))
(define A-TAT-BAK-T2X (symbol-append A-TAT-BAK 'apertium-tat-bak.tat-bak.t2x))
(define A-TAT-BAK-T2X-BIN (symbol-append A-TAT-BAK 'tat-bak.t2x.bin))
(define A-TAT-BAK-GEN (symbol-append A-TAT-BAK 'tat-bak.autogen.bin))
(define A-TAT-BAK-PGEN (symbol-append A-TAT-BAK 'tat-bak.autopgen.bin))

(define (tat-bak s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-bak")])
    (rash
     "echo (values s) | apertium -d . tat-bak")))

(define (tat-bak-from-pretransfer-to-biltrans s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-bak")])
    (rash
     "echo (values s) | apertium-pretransfer | "
     "lt-proc -b (values A-TAT-BAK-BIL)")))

(define (tat-bak-from-t1x-to-postgen s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-bak")])
    (rash
     "echo (values s) | "
     "apertium-transfer -b (values A-TAT-BAK-T1X) (values A-TAT-BAK-T1X-BIN) | "
     "apertium-transfer -n (values A-TAT-BAK-T2X) (values A-TAT-BAK-T2X-BIN) | "
     "lt-proc -g (values A-TAT-BAK-GEN) | "
     "lt-proc -p (values A-TAT-BAK-PGEN)")))

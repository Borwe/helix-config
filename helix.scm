(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(provide open-helix-scm open-init-scm st message)

(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))

(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))

;;@doc
;;Run steel command
(define (st obj)
  (eval! (trim  obj)))

;;@doc
;;Show message in logs
(define (message obj)
  (to-string obj))

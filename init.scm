(require (prefix-in helix.static. "helix/static.scm"))
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.editor. "helix/editor.scm"))
(require-builtin "steel/process" as process.)

(helix.theme "catppuccin_latte")

(define wakatime-version "0.1.0")
(define wakatime-agent "helix-wakatime")
(define wakatime-time-key "")
(define wakatime-exe "C:/Users/BRIAN/.wakatime/wakatime-cli.exe")

(define (wakatime-get-current-file)
         (Document-path(helix.editor.editor->get-document 
           (helix.editor.editor->doc-id 
             (helix.editor.editor-focus)))))
    
(define (wakatime-write c)
  (let* ((doc (wakatime-get-current-file))
         (cmd (process.command wakatime-exe (list 
                "--entity" doc
                "--plugin" 
                  (string-append wakatime-agent "/" wakatime-version)
               "--write"
                ))))
    
    (if doc (process.spawn-process cmd) #f)
    ))

(define (wakatime-listen-inserts )
  (register-hook! "post-insert-char" "wakatime-write"))
(wakatime-listen-inserts)

(define (run-wakatime)
  (displayln "LOL"))

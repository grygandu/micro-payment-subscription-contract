;; -----------------------------------------------------
;; SubPay: Decentralized Subscription Payments
;; -----------------------------------------------------
;; Enables recurring STX payments for subscription-based services.
;; Users authorize payments, and providers can claim funds per cycle.
;; -----------------------------------------------------

(define-constant ERR-UNAUTHORIZED u1001)
(define-constant ERR-INSUFFICIENT_BALANCE u1002)
(define-constant ERR-NOT-SUBSCRIBED u1003)
(define-constant ERR-ALREADY_SUBSCRIBED u1004)
(define-constant ERR-INVALID_AMOUNT u1005)

;; ------------------- Data Storage -------------------
(define-data-var subscription-counter uint u0)

(define-map subscriptions 
  { subscriber: principal, provider: principal }
  { amount: uint, interval: uint, last-payment: uint })

;; ------------------- Subscribe to a Plan -------------------
(define-public (subscribe (provider principal) (amount uint) (interval uint))
  (begin
    (asserts! (> amount u0) (err ERR-INVALID_AMOUNT))
    (asserts! (> interval u0) (err ERR-INVALID_AMOUNT))
    (asserts! (is-none (map-get? subscriptions { subscriber: tx-sender, provider: provider })) (err ERR-ALREADY_SUBSCRIBED))
    (map-set subscriptions { subscriber: tx-sender, provider: provider } 
      { amount: amount, interval: interval, last-payment: stacks-block-height })
    (ok "Subscription created.")
  )
)

;; ------------------- Process Payment -------------------
(define-public (claim-payment (subscriber principal))
  (let ((sub (map-get? subscriptions { subscriber: subscriber, provider: tx-sender })))
    (match sub
      some-sub
      (let ((next-payment (+ (get last-payment some-sub) (get interval some-sub)))
            (amount (get amount some-sub)))
        (begin
          (asserts! (<= next-payment stacks-block-height) (err ERR-UNAUTHORIZED))
          (match (stx-transfer? amount subscriber tx-sender)
            success
            (begin
              (map-set subscriptions { subscriber: subscriber, provider: tx-sender } 
                (merge some-sub { last-payment: stacks-block-height }))
              (ok "Payment claimed."))
            error (err ERR-INSUFFICIENT_BALANCE))))
      (err ERR-NOT-SUBSCRIBED))
  )
)

;; ------------------- Cancel Subscription -------------------
(define-public (cancel-subscription (provider principal))
  (begin
    (asserts! (is-some (map-get? subscriptions { subscriber: tx-sender, provider: provider })) (err ERR-NOT-SUBSCRIBED))
    (map-delete subscriptions { subscriber: tx-sender, provider: provider })
    (ok "Subscription canceled.")
  )
)

;; ------------------- Read-Only Functions -------------------
(define-read-only (get-subscription (subscriber principal) (provider principal))
  (ok (map-get? subscriptions { subscriber: subscriber, provider: provider }))
)

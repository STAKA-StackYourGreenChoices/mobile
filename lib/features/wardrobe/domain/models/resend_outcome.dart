/// What `POST /auth/resend-verification` did.
enum ResendOutcome {
  /// A new confirmation link was emailed.
  sent,

  /// Nothing to send: the email was confirmed already (e.g. on the website).
  alreadyConfirmed,
}

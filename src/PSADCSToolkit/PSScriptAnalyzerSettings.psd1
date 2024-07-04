@{
    # Severity = @()
    # IncludeRules = @()

    ExcludeRules = @(
        # Fails to suppress in scriptblocks
        'PSReviewUnusedParameter'
    )

    # You can use rule configuration to configure rules that support it:
    # Rules = @{
    # }
}

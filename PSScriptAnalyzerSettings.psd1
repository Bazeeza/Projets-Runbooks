@{
    # Errors and warnings fail the CI; information-level hints are only reported
    Severity     = @('Error', 'Warning')

    # PSAvoidUsingWriteHost: the CIS scripts are interactive console reports.
    # Their lines are meant for the operator's screen (or the -s file), not for
    # the pipeline, so Write-Host is the intended behavior here.
    ExcludeRules = @('PSAvoidUsingWriteHost')
}

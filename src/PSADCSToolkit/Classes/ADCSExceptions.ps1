class ADCSTemplateNotFoundException : System.Exception
{
    ADCSTemplateNotFoundException() { }
    ADCSTemplateNotFoundException([String] $message) : base($message) { }
    ADCSTemplateNotFoundException([System.String] $message, [System.Exception] $inner) : base($message, $inner) { }
}

class ADCSTemplateAlreadyExistsException : System.Exception
{
    ADCSTemplateAlreadyExistsException() { }
    ADCSTemplateAlreadyExistsException([String] $message) : base($message) { }
    ADCSTemplateAlreadyExistsException([System.String] $message, [System.Exception] $inner) : base($message, $inner) { }
}

class ADCSServerNotFoundException : System.Exception
{
    ADCSServerNotFoundException() { }
    ADCSServerNotFoundException([String] $message) : base($message) { }
    ADCSServerNotFoundException([System.String] $message, [System.Exception] $inner) : base($message, $inner) { }
}

class ADCSEnrollmentServiceNotFoundException : System.Exception
{
    ADCSEnrollmentServiceNotFoundException() { }
    ADCSEnrollmentServiceNotFoundException([String] $message) : base($message) { }
    ADCSEnrollmentServiceNotFoundException([System.String] $message, [System.Exception] $inner) : base($message, $inner) { }
}

class ADCSIssuancePolicyNotFoundException : System.Exception
{
    ADCSIssuancePolicyNotFoundException() { }
    ADCSIssuancePolicyNotFoundException([String] $message) : base($message) { }
    ADCSIssuancePolicyNotFoundException([System.String] $message, [System.Exception] $inner) : base($message, $inner) { }
}

class ADCSIssuancePolicyAlreadyExistsException : System.Exception
{
    ADCSIssuancePolicyAlreadyExistsException() { }
    ADCSIssuancePolicyAlreadyExistsException([String] $message) : base($message) { }
    ADCSIssuancePolicyAlreadyExistsException([System.String] $message, [System.Exception] $inner) : base($message, $inner) { }
}

class ADCSIssuancePolicyInvalidOperationException : System.Exception
{
    ADCSIssuancePolicyInvalidOperationException() { }
    ADCSIssuancePolicyInvalidOperationException([String] $message) : base($message) { }
    ADCSIssuancePolicyInvalidOperationException([System.String] $message, [System.Exception] $inner) : base($message, $inner) { }
}
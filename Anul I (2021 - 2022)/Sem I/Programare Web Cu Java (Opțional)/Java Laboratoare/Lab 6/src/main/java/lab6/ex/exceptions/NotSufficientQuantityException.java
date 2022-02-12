package lab6.ex.exceptions;

public class NotSufficientQuantityException extends RuntimeException {
    public NotSufficientQuantityException(String exceptionMsg) {
        super(exceptionMsg);
    }
}

// This is just a file to test that swift is functional. Ideally the src folder would be replaced with your server code
// which can easily be done by modifying the Dockerfile's ADD command... or by adding some functionality to git clone
// your repo.

func fibonacci(i: Int) -> Int {
    if i <= 2 {
        return 1
    } else {
        return fibonacci(i - 1) + fibonacci(i - 2)
    }
}

print(fibonacci(22))

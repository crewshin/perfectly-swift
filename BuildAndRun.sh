# Place logic in here to build and run your custom app.

swiftc -I /usr/local/lib -I /usr/local/include/libbson-1.0/ -c swift-router/URL Routing.xcworkspace
clang++ -L /swift/usr/lib/swift/linux -g -l Foundation -l swiftCore -l swiftGlibc /usr/local/lib/PerfectLib.so /usr/local/lib/PostgreSQL.so -Xlinker -rpath -Xlinker /swift/usr/lib/swift/linux app.o -o app

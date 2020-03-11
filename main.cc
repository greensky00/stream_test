
#include "test.grpc.pb.h"

#include <grpc++/grpc++.h>

#include "test_common.h"

#include <cstdint>
#include <memory>
#include <thread>

#include <stdio.h>

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;

namespace streamtest {

class StreamTestSvcImpl final : public StreamTestSvc::Service {
public:
    grpc::Status teststream( grpc::ServerContext* context,
                             grpc::ServerReaderWriter
                             < TestResp, TestReq>* stream ) override {
        TestSuite::Timer timer;
        TestSuite::Displayer dp(1, 3);
        dp.init();
        dp.setWidth({10, 20, 15});

        TestReq req;
        uint64_t rcvd_bytes = 0;
        while (stream->Read(&req)) {
            TestResp resp;
            rcvd_bytes += req.payload().size();
            dp.set(0, 0, "%zus", timer.getTimeSec());
            dp.set(0, 1, "received %s",
                   TestSuite::sizeToString(rcvd_bytes).c_str());
            dp.set(0, 2, "%zu", rcvd_bytes);
            dp.print();
            stream->Write(resp);
        }
        return Status::OK;
    }
};

} using namespace streamtest;

void run_server() {
    std::string server_address("localhost:55555");
    StreamTestSvcImpl service;

    ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);
    builder.SetMaxReceiveMessageSize( 32 * 1024 * 1024 );
    std::unique_ptr<Server> server(builder.BuildAndStart());
    std::cout << "Server listening on " << server_address << std::endl;

    server->Wait();
}

void run_client() {
    grpc::ChannelArguments ch_args;
    ch_args.SetMaxReceiveMessageSize(-1);

    std::unique_ptr<StreamTestSvc::Stub> stub(
        StreamTestSvc::NewStub(
            grpc::CreateCustomChannel(
                "localhost:55555",
                grpc::InsecureChannelCredentials(),
                ch_args ) ) );

    grpc::ClientContext ctx;
    std::unique_ptr< grpc::ClientReaderWriter
                     < TestReq, TestResp> > stream = stub->teststream(&ctx);

    std::string payload(10*1024*1024, 'x');
    TestSuite::WorkloadGenerator wg(20); // 20 ops/sec.
    for (uint64_t ii=0; ; ++ii) {
        size_t num = wg.getNumOpsToDo();
        if (!num) {
            TestSuite::sleep_ms(10);
            continue;
        }

        TestReq req;
        if (ii % 20 == 0) {
            // For every 20 ops, send big message.
            payload += std::string(1024, 'y');
            req.set_payload( payload );
        } else {
            // Otherwise
            req.set_payload( std::string(512, 'z') );
        }
        if (!stream->Write(req)) break;

        TestResp resp;
        if (!stream->Read(&resp)) break;

        wg.addNumOpsDone(1);
    }
}

int run() {
    std::thread t_srv(run_server);
    TestSuite::sleep_sec(1);
    std::thread t_client(run_client);
    t_srv.join();
    return 0;
}

int main(int argc, char** argv) {
    TestSuite ts(argc, argv);
    ts.options.printTestMessage = true;
    ts.doTest("stream test", run);
    return 0;
}



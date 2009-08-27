@import <Foundation/Foundation.j>

@import "OJTestCase.j"
@import "OJTestSuite.j"
@import "OJTestResult.j"

@import "OJTestListenerText.j"

CPLogRegister(CPLogPrint, "warn");

@implementation OJTestRunnerText : CPObject
{
    OJTestListener _listener;
}

- (id)init
{
    if (self = [super init])
    {
        _listener = [[OJTestListenerText alloc] init];
    }
    return self;
}

- (OJTest)getTest:(CPString)suiteClassName
{
    var testClass = objj_lookUpClass(suiteClassName);
    
    if (testClass)
    {
        var suite = [[OJTestSuite alloc] initWithClass:testClass];
        return suite;
    }
    
    CPLog.warn("unable to get tests");
    return nil;
}

- (void)startWithArguments:(CPArray)args
{
    var testCaseFile = args.shift();
    
    if (!testCaseFile)
    {
        [self report];
        return;
    }

    var matches = testCaseFile.match(/([^\/]+)\.j$/)
    print(matches[1]);
    var testCaseClass = matches[1];
        
    objj_import(testCaseFile, YES, function() {
        var suite = [self getTest:testCaseClass];

        [self run:suite];
        
        // run the next test when this is done
        [self startWithArguments:args];
    });
}

- (OJTestResult)run:(OJTest)suite wait:(BOOL)wait
{
    var result = [[OJTestResult alloc] init];
    
    [result addListener:_listener];
    
    [suite run:result];
    
    return result;
}
- (OJTestResult)run:(OJTest)suite
{
    return [self run:suite wait:NO];
}

+ (void)runTest:(OJTest)suite
{
    var runner = [[OJTestRunnerText alloc] init];
    [runner run:suite];
}

+ (void)runClass:(Class)aClass
{
    [self runTest:[[OJTestSuite alloc] initWithClass:aClass]];
}

- (void)report
{
    var totalErrors = [[_listener errors] count] + [[_listener failures] count];

    if (!totalErrors)
        return CPLog.info("End of all tests.");

    CPLog.fatal("Test suite failed with "+[[_listener errors] count]+" errors and "+[[_listener failures] count]+" failures.");
}

@end

function printUsage()
{
	print("Usage: ojtest ");
	quit();
}

function processArgs(args)
{
	if (args.length < 1)
	return printUsage();

	var index = 0,
	count = args.length;

    var unprocessed_args = [];
	for (; index < count; ++index)
	{
		var argument = args[index];

		switch (argument)
		{
			case "-v":
			case "--version":
			    print("ojtest version 0.7.1");
			    quit();

			case "-h":
			case "--help":
			    printUsage();
			    break;

            case "-I":
                
                break;

			default:
			    unprocessed_args.push(argument);
		}
	}
	
	return unprocessed_args;
}

args = processArgs(args);
print(args);

runner = [[OJTestRunnerText alloc] init];
[runner startWithArguments:args];

// getopt.j --- do C library getopt(3) function in Javascript
//
// Derived from getopt.awk by:
// Arnold Robbins, arnold@skeeve.com, Public Domain
// 
// Initial version: March, 1991
// Revised: May, 1993
//
// Javascript version: August 2009
// Wesley Moore, http://wezm.net/, Public Domain

// External variables:
//    optind -- index in ARGV of first nonoption argument
//    optarg -- string value of argument to current option
//    opterr -- if nonzero, print our own diagnostic
//    optopt -- current option letter

// Returns:
//    null     at end of options
//    ?      for unrecognized option
//    <c>    a character representing the current option

// Private Data:
//    _opti  -- index in multi-flag option, e.g., -abc
function getopt(args, options, thisopt, i)
{
    if (options.length == 0)     // no options given
        return null;

    if (args[optind] == "--") {  // all done
        optind++;
        _opti = 0;
        return null;
    } else if (argv[optind] !~ /^-[^: \t\n\f\r\v\b]/) {
        _opti = 0;
        return null;
    }
    if (_opti == 0)
        _opti = 2;
    thisopt = args[optind].charAt(_opti);
    optopt = thisopt;
    i = options.indexOf(thisopt);
    if (i == -1) {
        if (opterr)
            print(thisopt + " -- invalid option\n";
        if (_opti >= args[optind].length {
            optind++;
            _opti = 0;
        } else
            _opti++;
        return "?"
    }
    if ( options.charAt(i + 1) == ":") {
        // get option argument
        if (args[optind].charAt(_opti + 1) > 0) //length(substr(args[optind], _opti + 1)) > 0)
            optarg = args[optind].charAt(_opti + 1); //substr(args[optind], _opti + 1)
        else
            optarg = args[++optind];
        _opti = 0;
    } else
        optarg = "";
    if (_opti == 0 || _opti >= args[optind].length) {
        optind++;
        _opti = 0;
    } else
        _opti++;
    return thisopt;
}

BEGIN {
    opterr = 1    # default is to diagnose
    optind = 1    # skip ARGV[0]

    # test program
    if (_getopt_test) {
        while ((_go_c = getopt(ARGC, ARGV, "ab:cd")) != -1)
            printf("c = <%c>, optarg = <%s>\n",
                                       _go_c, optarg)
        printf("non-option arguments:\n")
        for (; optind < ARGC; optind++)
            printf("\tARGV[%d] = <%s>\n",
                                    optind, ARGV[optind])
    }
}

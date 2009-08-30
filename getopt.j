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
// optind = 0; // -- index in ARGV of first nonoption argument
// optarg; // -- string value of argument to current option
// opterr = 1; // -- if nonzero, print our own diagnostic
// optopt; // -- current option letter

// Returns:
//    null   at end of options
//    ?      for unrecognized option
//    <c>    a character representing the current option

// Private Data:
//    _opti  -- index in multi-flag option, e.g., -abc

GetOpt = {
    init: function() {
        this.optind = 0;
        this.optarg = null;
        this.opterr = 1;
        this.optopt = null;
        this._opti = -1;
    },
    getopt: function(args, options, thisopt, i) {
        if (options.length == 0)     // no options given
            return null;

        if (args[this.optind] == "--") {  // all done
            this.optind++;
            this._opti = -1;
            return null;
        } else if (!(args[this.optind] && args[this.optind].match(/^-[^: \t\n\f\r\v\b]/))) {
            this._opti = -1;
            return null;
        }
        if (this._opti == -1)
            this._opti = 1;
        thisopt = args[this.optind].charAt(this._opti);
        this.optopt = thisopt;
        i = options.indexOf(thisopt);
        if (i == -1) {
            if (this.opterr)
                print(thisopt + " -- invalid option");
            if (this._opti >= (args[this.optind].length - 1)) {
                this.optind++;
                this._opti = -1;
            } else
                this._opti++;
            return "?";
        }
        if ( options.charAt(i + 1) == ":") {
            // get option argument
            if (args[this.optind].substr(this._opti + 1).length > 0) //length(substr(args[optind], _opti + 1)) > 0)
                // Argument is cuddled with option, E.g. -p1
                this.optarg = args[this.optind].substr(this._opti + 1); //substr(args[optind], _opti + 1)
            else
                // Argument is the next one in the list
                this.optarg = args[++this.optind];
            this._opti = -1;
        } else
            this.optarg = "";
        // if (_opti == 0 || _opti >= length(argv[Optind])) {
        if (this._opti == -1 || this._opti >= (args[this.optind].length - 1)) {
            this.optind++;
            this._opti = -1;
        } else
            this._opti++;
        return thisopt;
    }
};

GetOpt.init();

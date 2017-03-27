# Benchmark( func[, optrec] )
#
# func - a function taking no arguments
# optrec - an optional record with various options
#
# Measures how long executing the given function "func" takes.
# In order to improve accuracy, it invokes the function repeatedly.
# Before each repetition, the garbage collector is run, and
# (unless turned off by an option) the random number generators
# are reset.
# At the end, it outputs the average, median, and std deviation.
#
# Example:
# gap> Benchmark(function() Factors(x^293-1); end);
# .................................................
# Performed 49 iterations, taking 201 milliseconds.
# average: 4.1 +/- 0.11 (+/- 3%)
# median: 4.06396484375
# rec( avg := 4.09581, counter := 49, median := 4.06396, std := 0.109638, total := 200.695, var := 0.0120205 )
#
#
# The following options are currently implemented:
#
#  minreps:  the minimal number of repetitions (default: 5);
#            the function will be executed at least that often,\
#            unless some other condition (maxreps exceeded, maxtime exceeded)
#            aborts the benchmark early.
#  mintime:  the minimal number of milliseconds that has to pass before
#            benchmarking ends (default: 200)
#            benchmarking will not stop before this time has passed,
#            unless some other condition (maxreps exceeded, maxtime exceeded)
#            aborts the benchmark early.
#  maxreps:  the maximal number of repetitions (default: infinity)
#            once this is reached, benchmarking stops immediately.
#  maxtime:  the minimal number of milliseconds before benchmarking ends (default: 200)
#            once this is reached, benchmarking stops immediately.
#  silent:   suppresses any output (default: false)
#  resetRandom:  whether to reset the random number generators before each repetition (default: true)
#
#
# TODO: allow passing a function that is executed before every test run.
# That function can reset other state, flush caches etc.
#
Benchmark := function(func, opt...)
    local getTime, timings, total, t, i, res;
    if Length(opt) = 1 and IsRecord(opt[1]) then
        opt := ShallowCopy(opt[1]);
    elif Length(opt) = 0 then
        opt := rec();
    else
        Error("Usage: Benchmark( func[, optrec] )");
    fi;

    if not IsBound( opt.minreps ) then opt.minreps := 5; fi;
    if not IsBound( opt.maxreps ) then opt.maxreps := infinity; fi;
    if not IsBound( opt.silent ) then opt.silent := false; fi;
    if not IsBound( opt.resetRandom ) then opt.resetRandom := true; fi;
    if not IsBound( opt.mintime ) then
        opt.mintime := 200.0;
    else
        opt.mintime := Float(opt.mintime);
    fi;
    if not IsBound( opt.maxtime ) then
        opt.maxtime := Float(infinity);
    else
        opt.maxtime := Float(opt.maxtime);
    fi;

    # if available, use NanosecondsSinceEpoch
    if IsBound(NanosecondsSinceEpoch) then
        getTime := function() return NanosecondsSinceEpoch()/1000000.; end;
    else
        getTime := Runtime;
    fi;

    timings := [];
    total := 0.0;
    i := 0;
    # repeat at most opt.maxreps times, and at least opt.minreps
    # times, resp. at least till opt.mintime milliseconds passed
    while i < opt.maxreps and (opt.maxtime = infinity or total < opt.maxtime) and
        (i < opt.minreps or total < opt.mintime) do
        i := i + 1;

        if opt.resetRandom then
            Reset(GlobalMersenneTwister);
            Reset(GlobalRandomSource);
        fi;
        GASMAN("collect");

        t := getTime();
        func();
        t := getTime() - t;

        total := total + t;
        Add(timings, t);
        if not opt.silent then
            Print(".\c");
        fi;
    od;
    if not opt.silent then
        Print("\n");
    fi;

    Sort(timings);

    res := rec();
    #res.timings := timings;
    res.total := total;
    res.counter := i;
    res.avg := Sum(timings) * 1.0 / res.counter;
    res.var := Sum(timings, t -> (t-res.avg)^2) / res.counter;
    res.std := Sqrt(res.var);
    if IsOddInt(res.counter) then
        res.median := timings[(res.counter+1)/2];
    else
        res.median := (timings[(res.counter)/2] + timings[(res.counter+2)/2]) / 2.;
    fi;

    if not opt.silent then
        Print("Performed ", res.counter, " iterations, taking ", Round(res.total), " milliseconds.\n");
        #Print("timings: ", timings, "\n");
        Print("average: ", Round(100*res.avg)/100,
            " +/- ", Round(100*res.std)/100,
            " (+/- ", Round(100*res.std/res.avg), "%)",
            "\n");
        Print("median: ", res.median, "\n");

    fi;

    return res;
end;

if false then
Benchmark(function() Factors(x^293-1); end);
Benchmark(function() Factors(x^293-1); end, rec(maxreps:=10));
fi;

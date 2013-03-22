import numpy as np
import scipy.optimize

def calculate_ec50(conc, responses, Logarithmic):
    '''EC50 Function to fit a dose-response data to a 4 parameter dose-response
       curve.

       Inputs: 1. a 1 dimensional array of drug concentrations
               2. the corresponding m x n array of responses
       Algorithm: generate a set of initial coefficients including the Hill
                  coefficient
                  fit the data to the 4 parameter dose-response curve using
                  nonlinear least squares
       Output: a matrix of the 4 parameters
               results[m,1]=min
               results[m,2]=max
               results[m,3]=ec50
               results[m,4]=Hill coefficient

       Original Matlab code Copyright 2004 Carlos Evangelista
       send comments to CCEvangelista@aol.com
       '''
    # If we are using a log-domain set of doses, we have a better chance of
    # fitting a sigmoid to the curve if the concentrations are
    # log-transformed.
    if Logarithmic:
        conc = np.log(conc)

    n=responses.shape[1]
    results=np.zeros((n,4))
    
    def error_fn(v, x, y):
        '''Least-squares error function
        
        This measures the least-squares error of fitting the sigmoid
        with parameters in v to the x and y data.
        '''
        return np.sum((sigmoid(v,x) - y)**2)
        
    for i in range(n):
        response=responses[:,i]
        v0 = calc_init_params(conc,response)
        v = scipy.optimize.fmin(error_fn, v0, args=(conc, response), 
                                maxiter=1000, maxfun = 1000,
                                disp=False)
        results[i,:] = v
    return results

def sigmoid(v, x):
        '''This is the EC50 sigmoid function
        
        v is a vector of parameters:
            v[0] = minimum allowed value
            v[1] = maximum allowed value
            v[2] = ec50
            v[3] = Hill coefficient
        '''
        p_min, p_max, ec50, hill = v
        return p_min + ((p_max - p_min) /
                        (1+(x/ec50)**hill))

def calc_init_params(x,y):
    '''This generates the min, max, x value at the mid-y value, and Hill
      coefficient. These values are starting points for the sigmoid fitting.

      x & y are the points to be fit
      returns minimum, maximum, ec50 and hill coefficient starting points
      '''
    min_0 = min(y)
    max_0 = max(y)

    # Parameter 3
    # OLD:  parms(3)=(min(x)+max(x))/2;
    # This is an estimate of the EC50, i.e. the half maximal effective
    # concentration (here denoted as x-value)
    #
    # Note: this was originally simply mean([max(x); min(x)]).  This does not
    # take into account the y-values though, so it was changed to be the 
    # x-value that corresponded to the y-value closest to the mean([max(y); min(y)]).
    # Unfortunately, for x-values with only two categories e.g. [0 1], this results in
    # an initial EC50 of either 0 or 1 (min(x) or max(x)), which seems a bad estimate.  
    # 5 We will take a two-pronged approach: Use the estimate from this latter approach, 
    # unless the parameter will equal either the max(x) or min(x).  In this case, we will use the
    # former approach, namely (mean([max(x); min(x)]).  DL 2007.09.24
    YvalueAt50thPercentile = (min(y)+max(y))/2
    DistanceToCentralYValue = np.abs(y - YvalueAt50thPercentile)
    LocationOfNearest = np.argmin(DistanceToCentralYValue)
    XvalueAt50thPercentile = x[LocationOfNearest]
    if XvalueAt50thPercentile == min(x) or XvalueAt50thPercentile == max(x):
        ec50 = (min(x)+max(x))/2
    else:
        ec50 = XvalueAt50thPercentile

    # Parameter 4
    # The OLD way used 'size' oddly - perhaps meant 'length'?  It would cause
    # divide-by-zero warnings since 'x(2)-x(sizex)' would necessarily have
    # zeros.
    # The NEW way just checks to see whether the depenmdent var is increasing (note
    # negative hillc) or descreasing (positive hillc) and sets them initally
    # to +/-1.  This could be smarter about how to initialize hillc, but +/-1 seems ok for now
    # DL 2007.09.25

    # OLD
    # sizey=size(y);
    # sizex=size(x);
    # if (y(1)-y(sizey))./(x(2)-x(sizex))>0
    #     init_params(4)=(y(1)-y(sizey))./(x(2)-x(sizex));
    # else
    #     init_params(4)=1;
    # end

    # I've made this look at the Y response at the minimum and maximum dosage
    # whereas before, it was looking at the Y response at the first and last
    # point which could just happen to be the same.
    min_idx = np.argmin(x)
    max_idx = np.argmax(x)
    x0 = x[min_idx]
    x1 = x[max_idx]
    y0 = y[min_idx]
    y1 = y[max_idx]
    
    if x0 == x1:
        # If all of the doses are the same, why are we doing this?
        # There's not much point in fitting.
        raise ValueError("All doses or labels for all image sets are %s. Can't calculate dose/response curves."%x0)
    elif y1 > y0:
        hillc = -1
    else:
        hillc = 1
    return (min_0, max_0, ec50, hillc)
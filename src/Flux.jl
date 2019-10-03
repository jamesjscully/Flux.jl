module Flux

# Zero Flux Given

using Base: tail
using Zygote, MacroTools, Juno, Reexport, Statistics, Random
using MacroTools: @forward
@reexport using NNlib
using Zygote: Params, @adjoint, gradient, pullback
export gradient

export Chain, Dense, Maxout, RNN, LSTM, GRU, Conv, CrossCor, ConvTranspose, MaxPool, MeanPool,
       DepthwiseConv, Dropout, AlphaDropout, LayerNorm, BatchNorm, InstanceNorm, GroupNorm,
       SkipConnection, params, fmap, cpu, gpu, f32, f64

include("optimise/Optimise.jl")
using .Optimise
using .Optimise: @epochs
export SGD, Descent, ADAM, Momentum, Nesterov, RMSProp,
  ADAGrad, AdaMax, ADADelta, AMSGrad, NADAM,
  ADAMW, RADAM, InvDecay, ExpDecay, WeightDecay

using CUDAapi
if has_cuda()
  using CuArrays
  use_cuda() = true
else
  use_cuda() = false
end

include("utils.jl")
include("onehot.jl")
include("functor.jl")

include("layers/stateless.jl")
include("layers/basic.jl")
include("layers/conv.jl")
include("layers/recurrent.jl")
include("layers/normalise.jl")

include("data/Data.jl")

include("deprecations.jl")

if use_cuda()
  include("cuda/cuda.jl")
end

function __init__()
  if has_cuda() != use_cuda()
      cachefile = if VERSION >= v"1.3-"
          Base.compilecache_path(Base.PkgId(Flux))
      else
          abspath(DEPOT_PATH[1], Base.cache_file_entry(Base.PkgId(Flux)))
      end
      rm(cachefile)
      error("Your set-up changed, and Flux.jl needs to be reconfigured. Please load the package again.")
  end
end

end # module

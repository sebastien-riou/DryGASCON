# DryGASCON accelerator demo

## Concept
[The accelerator](https://github.com/sebastien-riou/DryGASCON/blob/9498de54b91c934a7ca3b88088196c81a7d7aa10/Implementations/drygasconv1_hx8k_fpga/src/drygascon128.v) is implemented as standard verilog and [imported in SpinalHDL as a black box](https://github.com/sebastien-riou/DryGASCON/blob/9498de54b91c934a7ca3b88088196c81a7d7aa10/Implementations/drygasconv1_hx8k_fpga/src/main/scala/vexriscv/demo/MuraxUtiles.scala#L170-L201).

[A wrapper in SpinalHDL defines](https://github.com/sebastien-riou/DryGASCON/blob/9498de54b91c934a7ca3b88088196c81a7d7aa10/Implementations/drygasconv1_hx8k_fpga/src/main/scala/vexriscv/demo/MuraxUtiles.scala#L203-L297):
- mapping to an APB3 slave
- control registers layout 

The same control register layout is described in [the C header file](https://github.com/sebastien-riou/DryGASCON/blob/9498de54b91c934a7ca3b88088196c81a7d7aa10/Implementations/drygasconv1_hx8k_fpga/software/libs/drygascon128_apb.h), along with some basic access functions.

NOTE: the style of this wrapper is very close to what you would write in verilog i.e. this is probably a rather poor usage of SpinalHDL, butitworks (TM)

Finally the APB slave is instanciated in [Murax.scala](https://github.com/sebastien-riou/DryGASCON/blob/9498de54b91c934a7ca3b88088196c81a7d7aa10/Implementations/drygasconv1_hx8k_fpga/src/main/scala/vexriscv/demo/Murax.scala#L291-L292)
Since the base address for the APB bus [is set to 0xF0000000](https://github.com/sebastien-riou/DryGASCON/blob/9498de54b91c934a7ca3b88088196c81a7d7aa10/Implementations/drygasconv1_hx8k_fpga/src/main/scala/vexriscv/demo/Murax.scala#L272), the DryGASCON accelerator is mapped to address 0xF0030000, hence [the declaration at C level](https://github.com/sebastien-riou/DryGASCON/blob/9498de54b91c934a7ca3b88088196c81a7d7aa10/Implementations/drygasconv1_hx8k_fpga/software/projects/murax/libs/murax.h#L27).

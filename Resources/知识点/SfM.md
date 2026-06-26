---
source: "[[2026年6月26日]]"
tags: [概念]
---

SFM则是一个[[crossbar]]（交叉矩阵）结构，有多条的channel水平和垂直交错而成，每条channel提供8Gbps交换能力（supervisor720提供每channel 20Gpbs）。Crossbar交换网的扩展能力非常强，交换容量可以做的很大，基本不受硬件条件限制，目前单颗芯片[[交换容量]]在256G－700G之间，多颗芯片可以构建T级乃至几T容量的大型交换网络，足以满足当前和未来几年网络对交换容量的需求，并且随着硬件集成技术的进步，单颗Crossbar芯片支持的容量会更大。 CAT6500和SFM提供256Gbps交换能力和100million的包转发能力。720以下引擎每channel提供8Gbps带宽（即RX 8Gbps和TX 8Gbps）。Fabric-enabled模块连接CrossBar中一个channel，支持8Gbps带宽，同时也连接在32Gbps的switch bus上；Fabric-only模块连接CrossBar中2个channel，提供16Gbps带宽。连接线卡本地交换bus和SFM或main 32-Gbps switching bus的关键点叫做medusa，其实是一块ASIC芯片，用来处理双方的数据传输。交叉矩阵交换，和它的名字一样，结构像是一个横竖交叉的矩阵，只不过横线（输入端）和竖线（输出端）并不直接相连，而是透过一个场效电晶体 （FET）将每一个横线与竖线连接。如此，只要控制场效电晶体的开关，便可以决定那个输入和那个输出（或那些输出）可以进行交换。矩阵交换的最大优点是允许多个相互不冲突的交换同时进行，并支持点对多点（Multicast）的交换

## 相关

- [[GeoFuse-MV3D（几何融合多视角三维重建）]]
- [[多视角几何融合重建]]
- [[输入视角的掩码]]
- [[Marching Cubes]]
- [[稠密点云]]
- [[PSNR]]
- [[菲涅尔效应]]
- [[感知图像质量（LPIPS）]]

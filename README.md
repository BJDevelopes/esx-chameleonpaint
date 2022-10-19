## Description
A simple script to use an item to apply chameleon paint to vehicles in fivem. I haven't seen much discussion about the chameleon paint affects added in a recent DLC, so thought I would make very simple script to show how these new vehicle color indexes are applied. I have added a simple inventory icon for this item, and you must move `spraypaint.ogg` to your `interactsound` resource. I'm sure more can be done with this like adding indexes to `qb-customs` or adding job dependancy, but I will leave that to all of you to do. Hope this helps.

The meta and texture files found in the `data` and `stream` folders must be present for this to work.

## Changes made by me
- Ability to set item restriction to certain job (e.g mechanic) you can also disable this, see Config
- Ability to choose if you want the paint to save into garage, See Config
- **Please Note:** SQL file was only created for ESX with weight system, others using limit must modify it but it will work if done correctly

## Credit
- [MrZedo](https://github.com/MrZedo/Cameleon-Color) Used information and assets found in this repo to implement the primary effect.
- [JoeSzymkowiczFiveM](https://github.com/JoeSzymkowiczFiveM/qb-chameleonpaint) Original Code Source, converted QB to ESX + added some feature

## Dependencies
- ESX Framework [https://github.com/esx-framework]
- Mythic Progbar [https://github.com/HalCroves/mythic_progbar]
- OxMySQL [https://github.com/overextended/oxmysql] 
- For the colors to work you must be in GameBuild 2545 or 2699

## Preview
https://streamable.com/oes8d9

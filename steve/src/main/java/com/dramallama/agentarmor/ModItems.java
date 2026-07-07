package com.dramallama.agentarmor;

import net.minecraft.world.item.ArmorItem;
import net.minecraft.world.item.Item;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;

// This class creates the four AgentArmor items and registers them with Minecraft.
public class ModItems {
    // A "DeferredRegister" is Forge's safe way to add new items to the game.
    public static final DeferredRegister<Item> ITEMS =
            DeferredRegister.create(ForgeRegistries.ITEMS, AgentArmorMod.MOD_ID);

    // Each armor piece uses our AGENT material and a slot type (HELMET, etc.).
    public static final RegistryObject<Item> AGENT_HELMET = ITEMS.register("agent_helmet",
            () -> new ArmorItem(ModArmorMaterials.AGENT, ArmorItem.Type.HELMET, new Item.Properties()));

    public static final RegistryObject<Item> AGENT_CHESTPLATE = ITEMS.register("agent_chestplate",
            () -> new ArmorItem(ModArmorMaterials.AGENT, ArmorItem.Type.CHESTPLATE, new Item.Properties()));

    public static final RegistryObject<Item> AGENT_LEGGINGS = ITEMS.register("agent_leggings",
            () -> new ArmorItem(ModArmorMaterials.AGENT, ArmorItem.Type.LEGGINGS, new Item.Properties()));

    public static final RegistryObject<Item> AGENT_BOOTS = ITEMS.register("agent_boots",
            () -> new ArmorItem(ModArmorMaterials.AGENT, ArmorItem.Type.BOOTS, new Item.Properties()));
}

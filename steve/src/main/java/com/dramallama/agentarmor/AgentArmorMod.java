package com.dramallama.agentarmor;

import com.mojang.logging.LogUtils;
import net.minecraft.world.item.CreativeModeTabs;
import net.minecraftforge.event.BuildCreativeModeTabContentsEvent;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import org.slf4j.Logger;

// The @Mod annotation tells Forge this is the main class of our mod.
// The value must match the "modId" in src/main/resources/META-INF/mods.toml.
@Mod(AgentArmorMod.MOD_ID)
public class AgentArmorMod {
    // A short, all-lowercase id for our mod. Used everywhere Forge needs a name.
    public static final String MOD_ID = "agentarmor";

    // A logger so we can print messages to the game's console.
    public static final Logger LOGGER = LogUtils.getLogger();

    public AgentArmorMod() {
        IEventBus modEventBus = FMLJavaModLoadingContext.get().getModEventBus();

        // Register all of our items (the armor pieces) with the game.
        ModItems.ITEMS.register(modEventBus);

        // Tell Forge to call our addCreative method so the armor shows up
        // in the creative inventory.
        modEventBus.addListener(this::addCreative);

        LOGGER.info("AgentArmor mod loading! Suit up, agent. 🦙");
    }

    // Adds the four armor pieces to the "Combat" tab in the creative menu.
    private void addCreative(BuildCreativeModeTabContentsEvent event) {
        if (event.getTabKey() == CreativeModeTabs.COMBAT) {
            event.accept(ModItems.AGENT_HELMET.get());
            event.accept(ModItems.AGENT_CHESTPLATE.get());
            event.accept(ModItems.AGENT_LEGGINGS.get());
            event.accept(ModItems.AGENT_BOOTS.get());
        }
    }
}

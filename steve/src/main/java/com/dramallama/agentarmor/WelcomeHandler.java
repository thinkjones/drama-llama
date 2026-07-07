package com.dramallama.agentarmor;

import net.minecraft.ChatFormatting;
import net.minecraft.network.chat.Component;
import net.minecraft.network.protocol.game.ClientboundSetSubtitleTextPacket;
import net.minecraft.network.protocol.game.ClientboundSetTitleTextPacket;
import net.minecraft.network.protocol.game.ClientboundSetTitlesAnimationPacket;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.sounds.SoundEvents;
import net.minecraft.sounds.SoundSource;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraftforge.event.entity.player.PlayerEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;

// ============================================================================
//  🦙 CAMP DRAMA LLAMA — the fun part! 🦙
//  This runs every time a player joins a world. It shows a big welcome on the
//  screen, prints a friendly message, plays a cheerful sound, and hands the
//  player their very own Agent Armor set so they can see it right away.
//
//  Kids: try changing the words, the sound, or the colors below!
// ============================================================================
@Mod.EventBusSubscriber(modid = AgentArmorMod.MOD_ID)
public class WelcomeHandler {

    @SubscribeEvent
    public static void onPlayerJoin(PlayerEvent.PlayerLoggedInEvent event) {
        // This only runs on the server side, for a real player.
        if (!(event.getEntity() instanceof ServerPlayer player)) {
            return;
        }

        String agentName = player.getName().getString();

        // --- 1. A big title flashes on the screen -------------------------
        // Numbers are: fade-in, stay, fade-out (in game ticks; 20 ticks = 1 second).
        player.connection.send(new ClientboundSetTitlesAnimationPacket(10, 70, 20));
        player.connection.send(new ClientboundSetTitleTextPacket(
                Component.literal(">> Camp Drama Llama <<")
                        .withStyle(ChatFormatting.AQUA, ChatFormatting.BOLD)));
        player.connection.send(new ClientboundSetSubtitleTextPacket(
                Component.literal("Welcome, Agent " + agentName + "!")
                        .withStyle(ChatFormatting.YELLOW)));

        // --- 2. Friendly messages in the chat -----------------------------
        player.sendSystemMessage(Component.literal("===================================")
                .withStyle(ChatFormatting.DARK_AQUA));
        player.sendSystemMessage(Component.literal("   Welcome to Camp Drama Llama!")
                .withStyle(ChatFormatting.AQUA, ChatFormatting.BOLD));
        player.sendSystemMessage(Component.literal("   You are Agent " + agentName + ".")
                .withStyle(ChatFormatting.YELLOW));
        player.sendSystemMessage(Component.literal("   Your Agent Armor is in your bag. Suit up!")
                .withStyle(ChatFormatting.GREEN));
        player.sendSystemMessage(Component.literal("===================================")
                .withStyle(ChatFormatting.DARK_AQUA));

        // --- 3. A happy "level up" sound ----------------------------------
        player.level().playSound(null, player.blockPosition(),
                SoundEvents.PLAYER_LEVELUP, SoundSource.PLAYERS, 1.0F, 1.0F);

        // --- 4. Give the player their Agent Armor (only once) -------------
        // The check stops it from piling up every time they rejoin.
        if (!player.getInventory().contains(new ItemStack(ModItems.AGENT_HELMET.get()))) {
            giveItem(player, ModItems.AGENT_HELMET.get());
            giveItem(player, ModItems.AGENT_CHESTPLATE.get());
            giveItem(player, ModItems.AGENT_LEGGINGS.get());
            giveItem(player, ModItems.AGENT_BOOTS.get());
        }

        // --- 5. Build the Spy HQ near spawn (only the first time) ---------
        HeadquartersBuilder.buildIfNeeded(player.serverLevel(), player);
    }

    // Puts an item in the player's inventory, or drops it at their feet if full.
    private static void giveItem(ServerPlayer player, Item item) {
        ItemStack stack = new ItemStack(item);
        if (!player.getInventory().add(stack)) {
            player.drop(stack, false);
        }
    }
}

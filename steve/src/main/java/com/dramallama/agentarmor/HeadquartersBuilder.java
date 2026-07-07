package com.dramallama.agentarmor;

import net.minecraft.core.BlockPos;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.levelgen.Heightmap;

import java.util.Map;

// ============================================================================
//  🕵️ AGENT SPY HEADQUARTERS 🕵️
//  The first time someone joins the world, this builds a big Spy HQ near
//  spawn with a giant glowing "CAMP DRAMA LLAMA" sign, then drops the player
//  on the plaza right outside the front doors.
//
//  Kids: every size and block below is a variable you can change!
// ============================================================================
public class HeadquartersBuilder {

    // ---- Block palette (swap these for a totally different look) ----
    private static final BlockState PLAZA      = Blocks.POLISHED_ANDESITE.defaultBlockState();
    private static final BlockState TRIM       = Blocks.CYAN_CONCRETE.defaultBlockState();
    private static final BlockState WALL        = Blocks.GRAY_CONCRETE.defaultBlockState();
    private static final BlockState WINDOW      = Blocks.LIGHT_BLUE_STAINED_GLASS.defaultBlockState();
    private static final BlockState ROOF        = Blocks.SMOOTH_STONE.defaultBlockState();
    private static final BlockState LIGHT       = Blocks.SEA_LANTERN.defaultBlockState();
    private static final BlockState SIGN_LETTER = Blocks.SEA_LANTERN.defaultBlockState();
    private static final BlockState SIGN_PANEL  = Blocks.BLACK_CONCRETE.defaultBlockState();
    private static final BlockState FOUNDATION  = Blocks.STONE.defaultBlockState();
    private static final BlockState AIR         = Blocks.AIR.defaultBlockState();
    private static final BlockState MARKER      = Blocks.BEDROCK.defaultBlockState();

    // ---- Sizes (in blocks) ----
    private static final int PLAZA_W = 31;   // plaza width  (east-west, X)
    private static final int PLAZA_D = 25;   // plaza depth  (north-south, Z)
    private static final int HQ_W    = 15;   // building width
    private static final int HQ_D    = 9;    // building depth
    private static final int WALL_H  = 6;    // building wall height

    // Builds the HQ once per world. Safe to call on every player join.
    public static void buildIfNeeded(ServerLevel level, ServerPlayer player) {
        try {
            if (level.dimension() != Level.OVERWORLD) return;

            BlockPos spawn = level.getSharedSpawnPos();
            int ox = spawn.getX() - PLAZA_W / 2;   // plaza front-left corner X
            int oz = spawn.getZ() - 3;             // plaza front edge Z (near old spawn)
            int centerX = ox + PLAZA_W / 2;
            int centerZ = oz + PLAZA_D / 2;
            int plazaY = level.getHeight(Heightmap.Types.WORLD_SURFACE, centerX, centerZ) - 1;

            // A hidden bedrock block records "already built" so we never build twice.
            BlockPos marker = new BlockPos(ox - 2, plazaY, oz - 2);
            if (level.getBlockState(marker).is(Blocks.BEDROCK)) {
                return;
            }

            AgentArmorMod.LOGGER.info("Building the Camp Drama Llama Spy HQ near spawn...");

            buildPlaza(level, ox, oz, plazaY);
            int frontZ = buildHeadquarters(level, centerX, oz, plazaY);
            buildSign(level, centerX, frontZ, plazaY);

            // Remember we built it, set the world spawn out front, and move the player.
            level.setBlock(marker, MARKER, 2);
            int sx = centerX;
            int sz = oz + 3;                        // a few blocks in front of the doors
            level.setDefaultSpawnPos(new BlockPos(sx, plazaY + 1, sz), 0.0F);
            // yaw 0 = facing +Z (south) = looking straight at the HQ and its sign
            player.teleportTo(level, sx + 0.5, plazaY + 1, sz + 0.5, 0.0F, 0.0F);

            AgentArmorMod.LOGGER.info("Spy HQ complete. Welcome to Camp Drama Llama!");
        } catch (Exception e) {
            // Never let a build hiccup break a kid's login.
            AgentArmorMod.LOGGER.error("Could not build the Spy HQ", e);
        }
    }

    // Lays a flat plaza, filling gaps below and clearing terrain above.
    private static void buildPlaza(ServerLevel level, int ox, int oz, int plazaY) {
        for (int x = ox; x < ox + PLAZA_W; x++) {
            for (int z = oz; z < oz + PLAZA_D; z++) {
                boolean edge = (x == ox || x == ox + PLAZA_W - 1 || z == oz || z == oz + PLAZA_D - 1);
                level.setBlock(new BlockPos(x, plazaY, z), edge ? TRIM : PLAZA, 2);
                for (int y = plazaY - 1; y >= plazaY - 3; y--) {          // fill floating edges
                    BlockPos p = new BlockPos(x, y, z);
                    if (level.getBlockState(p).isAir()) level.setBlock(p, FOUNDATION, 2);
                }
                for (int y = plazaY + 1; y <= plazaY + WALL_H + 2; y++) { // clear trees/hills
                    level.setBlock(new BlockPos(x, y, z), AIR, 2);
                }
            }
        }
    }

    // Builds the HQ box (walls, windows, roof, lights, door). Returns the front-wall Z.
    private static int buildHeadquarters(ServerLevel level, int centerX, int oz, int plazaY) {
        int bx0 = centerX - HQ_W / 2;
        int bx1 = centerX + HQ_W / 2;
        int bz0 = oz + PLAZA_D - HQ_D - 1;   // front wall (faces the player)
        int bz1 = bz0 + HQ_D - 1;            // back wall
        int wallTop = plazaY + WALL_H;

        for (int x = bx0; x <= bx1; x++) {
            for (int z = bz0; z <= bz1; z++) {
                boolean wallX = (x == bx0 || x == bx1);
                boolean wallZ = (z == bz0 || z == bz1);
                if (wallX || wallZ) {
                    for (int y = plazaY + 1; y <= wallTop; y++) {
                        boolean windowBand = (y == plazaY + 3 || y == plazaY + 4);
                        boolean corner = wallX && wallZ;
                        level.setBlock(new BlockPos(x, y, z), (windowBand && !corner) ? WINDOW : WALL, 2);
                    }
                }
                level.setBlock(new BlockPos(x, wallTop + 1, z), ROOF, 2);          // roof
                if ((x - bx0) % 4 == 2 && (z - bz0) % 4 == 2) {                     // ceiling lights
                    level.setBlock(new BlockPos(x, wallTop, z), LIGHT, 2);
                }
            }
        }

        // Front door: a 3-wide, 3-tall opening in the middle of the front wall.
        for (int x = centerX - 1; x <= centerX + 1; x++) {
            for (int y = plazaY + 1; y <= plazaY + 3; y++) {
                level.setBlock(new BlockPos(x, y, bz0), AIR, 2);
            }
            level.setBlock(new BlockPos(x, plazaY, bz0 - 1), TRIM, 2);              // entrance strip
        }
        return bz0;
    }

    // Builds the giant glowing marquee: CAMP / DRAMA / LLAMA, on a black panel
    // between two pillars, towering above the HQ and facing the player.
    private static void buildSign(ServerLevel level, int centerX, int frontZ, int plazaY) {
        int wallTop = plazaY + WALL_H;
        int signTop = wallTop + 1 + 18;      // top row of the top line, high above the roof
        int signBottom = signTop - 16;       // bottom row of the bottom line
        int sx0 = centerX - 14, sx1 = centerX + 14;
        int panelZ = frontZ;                 // black backing sits on the front-wall plane
        int letterZ = frontZ - 1;            // glowing letters sit one block toward the player

        fillBox(level, sx0, signBottom - 1, panelZ, sx1, signTop + 1, panelZ, SIGN_PANEL);   // backing
        fillBox(level, sx0, plazaY + 1, panelZ, sx0, signBottom - 2, panelZ, WALL);          // left pillar
        fillBox(level, sx1, plazaY + 1, panelZ, sx1, signBottom - 2, panelZ, WALL);          // right pillar

        drawText(level, "CAMP",  centerX, signTop,      letterZ);
        drawText(level, "DRAMA", centerX, signTop - 6,  letterZ);
        drawText(level, "LLAMA", centerX, signTop - 12, letterZ);
    }

    // Fills a solid box between two corners (any order) with one block.
    private static void fillBox(ServerLevel level, int x0, int y0, int z0,
                                int x1, int y1, int z1, BlockState state) {
        int minX = Math.min(x0, x1), maxX = Math.max(x0, x1);
        int minY = Math.min(y0, y1), maxY = Math.max(y0, y1);
        int minZ = Math.min(z0, z1), maxZ = Math.max(z0, z1);
        for (int x = minX; x <= maxX; x++)
            for (int y = minY; y <= maxY; y++)
                for (int z = minZ; z <= maxZ; z++)
                    level.setBlock(new BlockPos(x, y, z), state, 2);
    }

    // Draws a word as big 5x5 block-letters on a vertical billboard facing -Z.
    private static void drawText(ServerLevel level, String text, int centerX, int topY, int z) {
        int width = text.length() * 6 - 1;           // 5 wide + 1 gap per letter
        int cursor = centerX - width / 2;
        for (char c : text.toCharArray()) {
            String[] glyph = FONT.get(c);
            if (glyph != null) {
                for (int row = 0; row < glyph.length; row++) {
                    for (int col = 0; col < glyph[row].length(); col++) {
                        if (glyph[row].charAt(col) == '1') {
                            level.setBlock(new BlockPos(cursor + col, topY - row, z), SIGN_LETTER, 2);
                        }
                    }
                }
            }
            cursor += 6;
        }
    }

    // A tiny 5x5 block font for just the letters in "CAMP DRAMA LLAMA".
    private static final Map<Character, String[]> FONT = Map.of(
        'C', new String[]{"01111", "10000", "10000", "10000", "01111"},
        'A', new String[]{"01110", "10001", "11111", "10001", "10001"},
        'M', new String[]{"10001", "11011", "10101", "10001", "10001"},
        'P', new String[]{"11110", "10001", "11110", "10000", "10000"},
        'D', new String[]{"11110", "10001", "10001", "10001", "11110"},
        'R', new String[]{"11110", "10001", "11110", "10010", "10001"},
        'L', new String[]{"10000", "10000", "10000", "10000", "11111"}
    );
}

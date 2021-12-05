
function showingDia() {
  if (!instance_exists(ctrl_Dialogue)) {
    return false;
  }
  return ctrl_Dialogue.dia_index < array_length(ctrl_Dialogue.dia);
}

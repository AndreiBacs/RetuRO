import { DataTypes, Model } from "denodb";

export class TomraTrigger extends Model {
  static override table = "tomra_triggers";

  static fields = {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, },
    trigger: { type: DataTypes.STRING, allowNull: false },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: () => new Date(),
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: () => new Date(),
    },
    processedAt: {
      type: DataTypes.DATE,
      allowNull: true,
    },
  };
}

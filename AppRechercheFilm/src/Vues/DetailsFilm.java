package Vues;/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.sql.Connection;

/**
 *
 * @author Nicolas
 */
public class DetailsFilm extends javax.swing.JFrame {

    Connection db;
    String idFilm;
    /**
     * Creates new form DetailsFilm
     */
    public DetailsFilm() {
        initComponents();
    }
    
    public DetailsFilm(Connection base, String id) {
        initComponents();
        db = base;
        idFilm = id;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        afficheLabel = new javax.swing.JLabel();
        idLabel = new javax.swing.JLabel();
        titreLabel = new javax.swing.JLabel();
        titreOLabel = new javax.swing.JLabel();
        statutLabel = new javax.swing.JLabel();
        idLabelX = new javax.swing.JLabel();
        titreLabelX = new javax.swing.JLabel();
        titreOrigiLabelX = new javax.swing.JLabel();
        statutLabelX = new javax.swing.JLabel();
        dateLabel = new javax.swing.JLabel();
        moyenneLabel = new javax.swing.JLabel();
        nbrVotesLabel = new javax.swing.JLabel();
        CertifLabel = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        moyenneLabelX = new javax.swing.JLabel();
        nbrVolsLabelX = new javax.swing.JLabel();
        certificationLabelX = new javax.swing.JLabel();
        dateLabelX = new javax.swing.JLabel();
        runtimeLabelX = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 141, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 145, Short.MAX_VALUE)
        );

        afficheLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        afficheLabel.setText("Affiche :");

        idLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        idLabel.setText("Id :");

        titreLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        titreLabel.setText("Titre :");

        titreOLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        titreOLabel.setText("Titre Original :");

        statutLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        statutLabel.setText("Statut :");

        idLabelX.setText("jLabel6");

        titreLabelX.setText("jLabel7");

        titreOrigiLabelX.setText("jLabel8");

        statutLabelX.setText("jLabel9");

        dateLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        dateLabel.setText("Date de sortie :");

        moyenneLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        moyenneLabel.setText("Moyenne des votes :");

        nbrVotesLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        nbrVotesLabel.setText("Nombre de votes :");

        CertifLabel.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        CertifLabel.setText("Certification :");

        jLabel14.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        jLabel14.setText("Runtime :");

        moyenneLabelX.setText("jLabel15");

        nbrVolsLabelX.setText("jLabel16");

        certificationLabelX.setText("jLabel17");

        dateLabelX.setText("jLabel18");

        runtimeLabelX.setText("jLabel19");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(afficheLabel)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(30, 30, 30)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(idLabel)
                                    .addComponent(titreLabel)
                                    .addComponent(titreOLabel)
                                    .addComponent(statutLabel)
                                    .addComponent(dateLabel)))
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(moyenneLabel)
                                    .addComponent(nbrVotesLabel)
                                    .addComponent(CertifLabel))
                                .addGap(18, 18, 18)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(certificationLabelX)
                                    .addComponent(moyenneLabelX)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(nbrVolsLabelX)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jLabel14)))))
                        .addGap(36, 36, 36)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(dateLabelX)
                            .addComponent(statutLabelX)
                            .addComponent(titreOrigiLabelX)
                            .addComponent(titreLabelX)
                            .addComponent(idLabelX)
                            .addComponent(runtimeLabelX))))
                .addContainerGap(57, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(14, 14, 14)
                .addComponent(afficheLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(idLabel)
                            .addComponent(idLabelX))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(titreLabel)
                            .addComponent(titreLabelX))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(titreOLabel)
                            .addComponent(titreOrigiLabelX))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(statutLabel)
                            .addComponent(statutLabelX))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(dateLabel)
                            .addComponent(dateLabelX))))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(moyenneLabel)
                    .addComponent(moyenneLabelX))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(nbrVotesLabel)
                    .addComponent(nbrVolsLabelX)
                    .addComponent(jLabel14)
                    .addComponent(runtimeLabelX))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(CertifLabel)
                    .addComponent(certificationLabelX))
                .addContainerGap(20, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(DetailsFilm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(DetailsFilm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(DetailsFilm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(DetailsFilm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new DetailsFilm().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel CertifLabel;
    private javax.swing.JLabel afficheLabel;
    private javax.swing.JLabel certificationLabelX;
    private javax.swing.JLabel dateLabel;
    private javax.swing.JLabel dateLabelX;
    private javax.swing.JLabel idLabel;
    private javax.swing.JLabel idLabelX;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JLabel moyenneLabel;
    private javax.swing.JLabel moyenneLabelX;
    private javax.swing.JLabel nbrVolsLabelX;
    private javax.swing.JLabel nbrVotesLabel;
    private javax.swing.JLabel runtimeLabelX;
    private javax.swing.JLabel statutLabel;
    private javax.swing.JLabel statutLabelX;
    private javax.swing.JLabel titreLabel;
    private javax.swing.JLabel titreLabelX;
    private javax.swing.JLabel titreOLabel;
    private javax.swing.JLabel titreOrigiLabelX;
    // End of variables declaration//GEN-END:variables
}

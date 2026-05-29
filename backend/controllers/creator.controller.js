const db = require('../config/database');

const getDashboard = async (req, res) => {
  try {
    const userId = req.user.userId;

    // Get user's creator status
    const userResult = await db.query(
      'SELECT is_creator, connect_count FROM users WHERE id = $1',
      [userId]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = userResult.rows[0];

    // Get campaign stats
    const campaignStats = await db.query(
      `SELECT 
        COUNT(DISTINCT ac.id) as total_campaigns,
        COALESCE(SUM(cvl.creator_share), 0) as total_earnings,
        COUNT(cvl.id) as total_views
       FROM ad_campaigns ac
       LEFT JOIN campaign_views_log cvl ON ac.id = cvl.campaign_id
       WHERE ac.creator_id = $1`,
      [userId]
    );

    const stats = campaignStats.rows[0];

    res.json({
      is_creator: user.is_creator,
      connect_count: user.connect_count,
      creator_threshold: parseInt(process.env.CREATOR_THRESHOLD || '3000'),
      total_campaigns: parseInt(stats.total_campaigns),
      total_earnings: parseFloat(stats.total_earnings),
      total_views: parseInt(stats.total_views),
    });
  } catch (error) {
    console.error('Get dashboard error:', error);
    res.status(500).json({ error: 'Failed to fetch dashboard data' });
  }
};

const listCampaigns = async (req, res) => {
  try {
    const result = await db.query(
      `SELECT ac.*, a.name as advertiser_name,
              (SELECT COUNT(*) FROM campaign_views_log WHERE campaign_id = ac.id) as view_count,
              (SELECT COALESCE(SUM(creator_share), 0) FROM campaign_views_log WHERE campaign_id = ac.id) as earnings
       FROM ad_campaigns ac
       JOIN advertisers a ON ac.advertiser_id = a.id
       WHERE ac.creator_id = $1
       ORDER BY ac.created_at DESC`,
      [req.user.userId]
    );

    res.json({ campaigns: result.rows });
  } catch (error) {
    console.error('List campaigns error:', error);
    res.status(500).json({ error: 'Failed to fetch campaigns' });
  }
};

const requestPayout = async (req, res) => {
  try {
    const { amount } = req.body;
    const minPayout = parseFloat(process.env.MIN_PAYOUT_AMOUNT || '100');

    if (!amount || amount < minPayout) {
      return res.status(400).json({ error: `Minimum payout amount is ${minPayout}` });
    }

    // Get available balance
    const balanceResult = await db.query(
      'SELECT COALESCE(SUM(creator_share), 0) as available_balance FROM campaign_views_log WHERE creator_id = $1',
      [req.user.userId]
    );

    const availableBalance = parseFloat(balanceResult.rows[0].available_balance);

    if (amount > availableBalance) {
      return res.status(400).json({ error: 'Insufficient balance' });
    }

    // TODO: Integrate with Stripe Connect for actual payout
    
    res.json({
      message: 'Payout request submitted',
      amount,
      status: 'pending',
      estimated_arrival: '3-5 business days',
    });
  } catch (error) {
    console.error('Request payout error:', error);
    res.status(500).json({ error: 'Failed to request payout' });
  }
};

module.exports = {
  getDashboard,
  listCampaigns,
  requestPayout,
};
